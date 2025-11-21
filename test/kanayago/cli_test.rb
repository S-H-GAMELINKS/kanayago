# frozen_string_literal: true

require_relative '../test_helper'
require 'tempfile'

module Kanayago
  class CLITest < Minitest::Test
    def test_check_valid_code
      output = capture_output do
        Kanayago::CLI.start(['check', 'p 117'])
      rescue SystemExit => e
        assert_equal 0, e.status
      end

      assert_match(/Syntax valid/, output)
    end

    def test_check_invalid_code
      output = capture_output do
        Kanayago::CLI.start(['check', 'def foo'])
      rescue SystemExit => e
        assert_equal 1, e.status
      end

      assert_match(/Syntax invalid/, output)
    end

    def test_check_file_with_valid_syntax
      Tempfile.create(['test', '.rb']) do |file|
        file.write('p 117')
        file.flush

        output = capture_output do
          Kanayago::CLI.start(['check', '--file', file.path])
        rescue SystemExit => e
          assert_equal 0, e.status
        end

        assert_match(/Syntax valid/, output)
      end
    end

    def test_check_file_with_invalid_syntax
      Tempfile.create(['test', '.rb']) do |file|
        file.write('def foo')
        file.flush

        output = capture_output do
          Kanayago::CLI.start(['check', '--file', file.path])
        rescue SystemExit => e
          assert_equal 1, e.status
        end

        assert_match(/Syntax invalid/, output)
      end
    end

    def test_check_file_short_option
      Tempfile.create(['test', '.rb']) do |file|
        file.write('p 117')
        file.flush

        output = capture_output do
          Kanayago::CLI.start(['check', '-f', file.path])
        rescue SystemExit => e
          assert_equal 0, e.status
        end

        assert_match(/Syntax valid/, output)
      end
    end

    def test_check_nonexistent_file
      output = capture_output do
        Kanayago::CLI.start(['check', '--file', 'nonexistent.rb'])
      rescue SystemExit => e
        assert_equal 1, e.status
      end

      assert_match(/File not found/, output)
    end

    private

    def capture_output
      original_stdout = $stdout
      $stdout = StringIO.new
      yield
      $stdout.string
    ensure
      $stdout = original_stdout
    end
  end
end
