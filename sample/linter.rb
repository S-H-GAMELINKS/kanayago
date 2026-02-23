# frozen_string_literal: true

require 'optparse'
require 'yaml'
require_relative '../lib/kanayago'

class LightweightLinter
  Offense = Struct.new(:path, :rule, :message, keyword_init: true)

  def initialize(config_path:, file_paths:)
    @config_path = config_path
    @file_paths = file_paths
  end

  def run
    validate_inputs!
    config = load_config
    rules = load_rules(config)

    offenses = []
    inspected = 0

    @file_paths.each do |path|
      offenses.concat(check_file(path, rules))
      inspected += 1
    end

    report(offenses, inspected)
    exit(offenses.empty? ? 0 : 1)
  rescue StandardError => e
    warn "Error: #{e.message}"
    exit 1
  end

  private

  def validate_inputs!
    raise 'Please provide --config PATH' unless @config_path
    raise 'Please provide at least one Ruby file to lint' if @file_paths.empty?

    @file_paths.each do |path|
      raise "File not found: #{path}" unless File.exist?(path)
    end
  end

  def load_config
    config = YAML.load_file(@config_path)
    raise 'Config root must be a mapping' unless config.is_a?(Hash)
    raise "Config must include 'rules'" unless config['rules'].is_a?(Array)

    config
  end

  def config_dir
    @config_dir ||= File.dirname(File.expand_path(@config_path))
  end

  def load_rules(config)
    config['rules'].filter_map do |entry|
      raise 'Each rule must be a mapping' unless entry.is_a?(Hash)

      enabled = entry.key?('enabled') ? entry['enabled'] : true
      next unless enabled

      name = entry.fetch('name')
      file = entry.fetch('file')
      class_name = entry.fetch('class')

      rule_file = File.expand_path(file, config_dir)
      raise "Rule file not found: #{rule_file}" unless File.exist?(rule_file)

      require rule_file

      klass = constantize(class_name)
      [name, klass.new]
    end
  end

  def constantize(name)
    name.split('::').inject(Object) { |mod, const| mod.const_get(const) }
  rescue NameError
    raise "Rule class not found: #{name}"
  end

  def check_file(path, rules)
    source = File.read(path)
    result = Kanayago.parse(source)

    return [parse_error_offense(path, result.error)] if result.invalid?

    rules.flat_map do |rule_name, rule|
      raw_offenses = rule.check(ast: result.ast, source: source, path: path)
      normalize_offenses(path, rule_name, raw_offenses)
    rescue StandardError => e
      raise "Rule execution failed (#{rule_name}): #{e.class}: #{e.message}"
    end
  end

  def normalize_offenses(path, rule_name, raw_offenses)
    raise "Rule '#{rule_name}' must return an Array" unless raw_offenses.is_a?(Array)

    raw_offenses.map do |offense|
      raise "Rule '#{rule_name}' returned non-Hash offense" unless offense.is_a?(Hash)

      message = offense[:message] || offense['message']
      raise "Rule '#{rule_name}' offense must include :message" if message.nil? || message.to_s.empty?

      rule = offense[:rule] || offense['rule'] || rule_name

      Offense.new(path: path, rule: rule.to_s, message: message.to_s)
    end
  end

  def parse_error_offense(path, error)
    Offense.new(path: path, rule: 'parse_error', message: error.message)
  end

  def report(offenses, inspected)
    offenses.each do |offense|
      puts "#{offense.path}: #{offense.rule}: #{offense.message}"
    end

    puts "#{inspected} files inspected, #{offenses.length} offenses detected"
  end
end

options = { config: nil }

option_parser = OptionParser.new do |opts|
  opts.banner = 'Usage: ruby sample/linter.rb check --config CONFIG file1.rb [file2.rb ...]'
  opts.on('--config PATH', 'Path to lint config YAML') { |v| options[:config] = v }
  opts.on('-h', '--help', 'Show this message') do
    puts opts
    exit 0
  end
end

argv = ARGV.dup
command = argv.shift

unless command == 'check'
  warn "Error: unknown command '#{command}'"
  warn option_parser.to_s
  exit 1
end

option_parser.parse!(argv)

LightweightLinter.new(config_path: options[:config], file_paths: argv).run
