# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/extensiontask"
require "fileutils"

COPY_TARGETS = %w[
  ccan/check_type/check_type.h
  ccan/container_of/container_of.h
  ccan/list/list.h
  ccan/str/str.h
  internal/array.h
  internal/basic_operators.h
  internal/bignum.h
  internal/bits.h
  internal/compile.h
  internal/compilers.h
  internal/complex.h
  internal/encoding.h
  internal/error.h
  internal/fixnum.h
  internal/gc.h
  internal/hash.h
  internal/imemo.h
  internal/io.h
  internal/numeric.h
  internal/parse.h
  internal/rational.h
  internal/re.h
  internal/ruby_parser.h
  internal/sanitizers.h
  internal/serial.h
  internal/static_assert.h
  internal/string.h
  internal/symbol.h
  internal/thread.h
  internal/warnings.h
  internal/vm.h
  internal.h
  method.h
  node.c
  node.h
  parser_bits.h
  parser_node.h
  parser_st.c
  parser_st.h
  parser_value.h
  ruby_assert.h
  ruby_atomic.h
  ruby_parser.c
  rubyparser.h
  st.c
  symbol.h
  thread_pthread.h
  universal_parser.c
  vm_core.h
  vm_opts.h
]

namespace :ruby_parser do
  desc "import ruby parser files"
  task :import do
    `git clone https://github.com/ruby/ruby.git tmp/ruby --depth=1`

    dist = File.expand_path("../ext/mjollnir/ruby-parser", __FILE__)
    ruby_dir = File.expand_path("../tmp/ruby", __FILE__)

    COPY_TARGETS.each do |target|
      FileUtils.mv File.join(ruby_dir, target), File.join(dist, target), force: true
    end

    # "parse.tmp.y"
    id2token_path = File.join(ruby_dir, "tool/id2token.rb")
    parse_y_path = File.join(dist, "parse.y")
    parse_tmp_y_path = File.join(dist, "parse.tmp.y")
    sh "ruby #{id2token_path} #{parse_y_path} > #{parse_tmp_y_path}"

    # "id.h"
    generic_erb_path = File.join(ruby_dir, "tool/generic_erb.rb")
    id_h_tmpl_path = File.join(ruby_dir, "template/id.h.tmpl")
    id_h_path = File.join(dist, "id.h")
    sh "ruby #{generic_erb_path} --output=#{id_h_path} #{id_h_tmpl_path}"

    # "probes.h"
    probes_h_path = File.join(dist, "probes.h")
    File.open(probes_h_path, "w+") do |f|
      f << <<~SRC
        #define RUBY_DTRACE_PARSE_BEGIN_ENABLED() (0)
        #define RUBY_DTRACE_PARSE_BEGIN(arg0, arg1) (void)(arg0), (void)(arg1);
        #define RUBY_DTRACE_PARSE_END_ENABLED() (0)
        #define RUBY_DTRACE_PARSE_END(arg0, arg1) (void)(arg0), (void)(arg1);
      SRC
    end

    # "node_name.inc"
    node_name_path = File.join(ruby_dir, "tool/node_name.rb")
    rubyparser_h_path = File.join(dist, "rubyparser.h")
    node_name_inc_path = File.join(dist, "node_name.inc")
    sh "ruby -n #{node_name_path} < #{rubyparser_h_path} > #{node_name_inc_path}"

    `rm -rf tmp/ruby`
  end
end

task build: :compile

GEMSPEC = Gem::Specification.load("mjollnir.gemspec")

Rake::ExtensionTask.new("mjollnir", GEMSPEC) do |ext|
  ext.lib_dir = "lib/mjollnir"
end

task default: %i[clobber compile]
