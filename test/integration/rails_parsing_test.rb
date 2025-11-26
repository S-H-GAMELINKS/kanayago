# frozen_string_literal: true

require_relative '../test_helper'

class RailsParsingTest < Minitest::Test
  REPOS_DIR = File.expand_path('../../tmp/integration_repos', __dir__)

  def setup
    @parse_errors = []
    @parse_stats = {
      total_files: 0,
      parsed_files: 0,
      failed_files: 0,
      skipped_files: 0
    }
  end

  def teardown
    return unless @parse_stats[:total_files].positive?

    # Output statistics
    success_rate = (@parse_stats[:parsed_files].to_f / @parse_stats[:total_files] * 100).round(2)
    puts <<~STATS

      #{'=' * 80}
      Parse Statistics:
        Total files: #{@parse_stats[:total_files]}
        Parsed successfully: #{@parse_stats[:parsed_files]}
        Failed: #{@parse_stats[:failed_files]}
        Skipped: #{@parse_stats[:skipped_files]}
        Success rate: #{success_rate}%
      #{'=' * 80}
    STATS

    # Output errors if any
    return unless @parse_errors.any?

    puts "\nParse Errors (showing first 10):"
    @parse_errors.first(10).each do |error|
      puts <<~ERROR

        File: #{error[:file]}
        Error: #{error[:error].class.name}
        Message: #{error[:error].message}
        Location: #{error[:error].backtrace&.first}
      ERROR
    end
    puts "\n  ... and #{@parse_errors.size - 10} more errors" if @parse_errors.size > 10
  end

  def test_parse_rails_codebase
    rails_path = File.join(REPOS_DIR, 'rails')
    skip "Rails repository not found. Run 'rake integration:setup' first." unless File.directory?(rails_path)

    puts "\nTesting Rails codebase at: #{rails_path}"

    # Parse main Rails components
    [
      'activesupport/lib',
      'activerecord/lib',
      'actionpack/lib',
      'actionview/lib',
      'activejob/lib',
      'actionmailer/lib',
      'actioncable/lib',
      'activestorage/lib',
      'railties/lib'
    ].each do |component_path|
      full_path = File.join(rails_path, component_path)
      parse_directory(full_path) if File.directory?(full_path)
    end

    assert_parsing_results
  end

  def test_parse_discourse_codebase
    discourse_path = File.join(REPOS_DIR, 'discourse')
    skip "Discourse repository not found. Run 'rake integration:setup' first." unless File.directory?(discourse_path)

    puts "\nTesting Discourse codebase at: #{discourse_path}"

    %w[app lib spec].each do |dir|
      full_path = File.join(discourse_path, dir)
      parse_directory(full_path) if File.directory?(full_path)
    end

    assert_parsing_results
  end

  def test_parse_mastodon_codebase
    mastodon_path = File.join(REPOS_DIR, 'mastodon')
    skip "Mastodon repository not found. Run 'rake integration:setup' first." unless File.directory?(mastodon_path)

    puts "\nTesting Mastodon codebase at: #{mastodon_path}"

    %w[app lib spec].each do |dir|
      full_path = File.join(mastodon_path, dir)
      parse_directory(full_path) if File.directory?(full_path)
    end

    assert_parsing_results
  end

  def test_parse_gitlab_codebase
    gitlab_path = File.join(REPOS_DIR, 'gitlab')
    skip "GitLab repository not found. Run 'rake integration:setup' first." unless File.directory?(gitlab_path)

    puts "\nTesting GitLab codebase at: #{gitlab_path}"

    %w[app lib spec].each do |dir|
      full_path = File.join(gitlab_path, dir)
      parse_directory(full_path) if File.directory?(full_path)
    end

    assert_parsing_results
  end

  private

  def parse_directory(dir_path)
    Dir.glob(File.join(dir_path, '**', '*.rb')).each do |file_path|
      parse_file(file_path)
    end
  end

  def parse_file(file_path)
    @parse_stats[:total_files] += 1

    # Skip files that are known to be problematic or not standard Ruby
    if should_skip_file?(file_path)
      @parse_stats[:skipped_files] += 1
      return
    end

    begin
      content = File.read(file_path, encoding: 'UTF-8')
      result = Kanayago.parse(content)

      if result.valid?
        @parse_stats[:parsed_files] += 1
      else
        @parse_stats[:failed_files] += 1
        @parse_errors << {
          file: file_path,
          error: result.error || StandardError.new('Unknown parse error')
        }
      end
    rescue StandardError => e
      @parse_stats[:failed_files] += 1
      @parse_errors << {
        file: file_path,
        error: e
      }
    end
  end

  def should_skip_file?(file_path)
    # Skip vendor and generated files
    return true if file_path.include?('/vendor/')

    # Skip node_modules
    return true if file_path.include?('/node_modules/')

    # Skip fixture files that may contain intentionally invalid syntax
    return true if file_path.include?('/fixtures/')

    false
  end

  def assert_parsing_results
    # Assert that we found and processed files
    assert_predicate @parse_stats[:total_files], :positive?, 'No Ruby files were found to parse'

    # Assert high success rate (allow some failures for edge cases)
    success_rate = @parse_stats[:parsed_files].to_f / @parse_stats[:total_files]

    assert_operator success_rate, :>=, 0.95, "Parse success rate #{(success_rate * 100).round(2)}% is below 95%. " \
                                             "#{@parse_stats[:failed_files]} files failed to parse."
  end
end
