#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'

# Ruby parser setup script for Kanayago
# This script downloads Ruby source code and prepares parser files for building
module KanayagoSetup
  class << self
    def run
      puts 'Setting up Ruby parser files for Kanayago...'

      # Determine Ruby version
      ruby_version = detect_ruby_version
      puts "Detected Ruby version: #{ruby_version}"

      # Load copy targets for this Ruby version
      load_copy_targets(ruby_version)

      # Import parser files
      import_parser_files(ruby_version)

      # Apply patch
      apply_patch(ruby_version)

      puts 'Setup completed successfully!'
    rescue StandardError => e
      warn "Error during setup: #{e.message}"
      warn e.backtrace.join("\n")
      exit 1
    end

    private

    def detect_ruby_version
      # Ruby head (master branch) has 'dev' in description but not a release version
      # Ruby 3.4.0 also had 'dev' in its preview/rc releases, so check RUBY_VERSION
      if RUBY_DESCRIPTION.include?('dev') && !RUBY_VERSION.start_with?('3.4')
        'head'
      else
        # Try exact version first (e.g., "3.4.1"), fallback to major.minor (e.g., "3.4")
        exact_version = RUBY_VERSION
        major_minor = RUBY_VERSION[0..2]

        patch_dir = File.expand_path('../patch', __dir__)
        if Dir.exist?(File.join(patch_dir, exact_version))
          exact_version
        else
          major_minor
        end
      end
    end

    def load_copy_targets(version)
      # Try exact version first, then fallback to major.minor
      copy_target_path = File.expand_path("../patch/#{version}/copy_target.rb", __dir__)

      unless File.exist?(copy_target_path)
        fallback_version = version[0..2]
        copy_target_path = File.expand_path("../patch/#{fallback_version}/copy_target.rb", __dir__)
      end

      raise "Copy target file not found: #{copy_target_path}" unless File.exist?(copy_target_path)

      require copy_target_path
    end

    def import_parser_files(version) # rubocop:disable Metrics/PerceivedComplexity
      puts 'Importing Ruby parser files...'

      tar_name = if version == 'head'
                   'snapshot/snapshot-master.tar.gz'
                 else
                   # Use major.minor for directory path (e.g., "3.4")
                   major_minor = RUBY_VERSION[0..2]
                   "#{major_minor}/ruby-#{RUBY_VERSION}.tar.gz"
                 end

      # Get project root directory
      project_root = File.expand_path('..', __dir__)
      tmp_dir = File.join(project_root, 'tmp')
      tmp_ruby_dir = File.join(tmp_dir, 'ruby')
      tmp_tar_file = File.join(tmp_dir, 'ruby.tar.gz')

      # Create temporary directory
      FileUtils.mkdir_p(tmp_ruby_dir)

      # Download Ruby source
      puts 'Downloading Ruby source from cache.ruby-lang.org...'
      system("curl -L https://cache.ruby-lang.org/pub/ruby/#{tar_name} -o #{tmp_tar_file}") ||
        raise('Failed to download Ruby source')

      # Extract
      puts 'Extracting Ruby source...'
      system("tar -zxf #{tmp_tar_file} -C #{tmp_ruby_dir} --strip-components 1") ||
        raise('Failed to extract Ruby source')

      dist = File.join(project_root, 'ext', 'kanayago')

      # Create necessary directories
      MAKE_DIRECTORIES.each do |dir|
        dir_path = File.join(dist, dir)
        FileUtils.mkdir_p(dir_path)
      end

      # Copy files
      puts 'Copying parser files...'
      RUBY_PARSER_COPY_TARGETS.each do |target|
        src = File.join(tmp_ruby_dir, target)
        dst = File.join(dist, target)

        if File.exist?(src)
          FileUtils.cp(src, dst)
        else
          warn "Warning: Source file not found: #{src}"
        end
      end

      # Generate probes.h
      puts 'Generating probes.h...'
      probes_h_path = File.join(dist, 'probes.h')
      File.open(probes_h_path, 'w+') do |f|
        f << <<~SRC
          #define RUBY_DTRACE_PARSE_BEGIN_ENABLED() (0)
          #define RUBY_DTRACE_PARSE_BEGIN(arg0, arg1) (void)(arg0), (void)(arg1);
          #define RUBY_DTRACE_PARSE_END_ENABLED() (0)
          #define RUBY_DTRACE_PARSE_END(arg0, arg1) (void)(arg0), (void)(arg1);
        SRC
      end

      # Cleanup
      puts 'Cleaning up temporary files...'
      FileUtils.rm_rf(tmp_ruby_dir)
      FileUtils.rm_f(tmp_tar_file)
    end

    def apply_patch(version)
      puts "Applying patch for Ruby #{version}..."

      patch_file = File.expand_path("../patch/#{version}/kanayago.patch", __dir__)

      raise "Patch file not found: #{patch_file}" unless File.exist?(patch_file)

      # Change to project root directory before applying patch
      project_root = File.expand_path('..', __dir__)
      Dir.chdir(project_root) do
        system("patch -p1 < #{patch_file}") ||
          raise('Failed to apply patch')

        # Apply macOS-specific patch if on macOS
        apply_macos_patch(version)
      end
    end

    def apply_macos_patch(version)
      return unless macos?

      macos_patch_file = File.expand_path("../patch/#{version}/macos.patch", __dir__)
      return unless File.exist?(macos_patch_file)

      puts "Applying macOS-specific patch for Ruby #{version}..."
      system("patch -p1 < #{macos_patch_file}") ||
        raise('Failed to apply macOS patch')
    end

    def macos?
      RUBY_PLATFORM.include?('darwin')
    end
  end
end

# Run setup if this script is executed directly
KanayagoSetup.run if __FILE__ == $PROGRAM_NAME
