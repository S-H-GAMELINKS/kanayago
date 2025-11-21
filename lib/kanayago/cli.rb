# frozen_string_literal: true

require 'optparse'

module Kanayago
  class CLI
    def self.start(argv)
      new(argv).run
    end

    def initialize(argv)
      @argv = argv
      @file = nil
    end

    def run
      if @argv.empty?
        puts "Usage: kanayago check 'code' or kanayago check --file FILE"
        exit 1
      end

      command = @argv.shift

      case command
      when 'check'
        check_command
      else
        puts "Unknown command: #{command}"
        puts "Usage: kanayago check 'code' or kanayago check --file FILE"
        exit 1
      end
    end

    private

    def check_command
      parse_options

      if @file
        check_file(@file)
      elsif @argv.empty?
        puts 'Error: Please provide Ruby code or use --file option'
        exit 1
      else
        code = @argv.join(' ')
        check_code(code)
      end
    end

    def parse_options
      OptionParser.new do |opts|
        opts.banner = "Usage: kanayago check [options] 'code'"

        opts.on('-f FILE', '--file FILE', 'Check syntax of Ruby file') do |file|
          @file = file
        end

        opts.on('-h', '--help', 'Show this message') do
          puts opts
          exit
        end
      end.parse!(@argv)
    end

    def check_code(code)
      result = Kanayago.parse(code)

      if result.valid?
        puts 'Syntax valid'
        exit 0
      else
        puts 'Syntax invalid'
        exit 1
      end
    end

    def check_file(file_path)
      unless File.exist?(file_path)
        puts "Error: File not found: #{file_path}"
        exit 1
      end

      code = File.read(file_path)
      check_code(code)
    rescue StandardError => e
      puts "Error: #{e.message}"
      exit 1
    end
  end
end
