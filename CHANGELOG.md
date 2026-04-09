# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Add support for Ruby 3.4.9
- Add support for Ruby 4.0.2
- Add Ruby 3.4.9 and 4.0.2 to the CI test matrix

## [0.8.1] - 2026-03-06

### Fixed
- Fix build failure when install path contains spaces

## [0.8.0] - 2026-02-23

### Added
- Add support for pattern matching
- Add Windows CI workflow (`.github/workflows/windows.yml`)

## [0.7.0] - 2026-01-01

### Fixed
- Fix segmentation fault on macOS caused by unexported Ruby C APIs
  - Several Ruby C APIs (`rb_reg_compile`, `rb_enc_literal_str`, etc.) are not exported on macOS
  - Add macOS-specific patch (`patch/head/macos.patch`) that replaces unexported APIs with compatible public APIs
  - Use own parser config in `kanayago.c` to avoid unexported APIs

### Added
- Add support Ruby 4.0.0
- Add macOS support
  - Add macOS CI workflow (`.github/workflows/macos.yml`)
  - Add `apply_macos_patch` function in `script/setup_parser.rb`
- Add support for each Ruby 3.4.x patch versions (3.4.0 - 3.4.8)
  - Add individual patch files and `copy_target.rb` for each version
- Update Ubuntu CI to test multiple Ruby versions
- Add integration tests for parsing real-world Rails codebases
  - Add `test/integration/rails_parsing_test.rb` for testing Rails, Discourse, Mastodon, and GitLab codebases
  - Add `rake integration:setup` task to automatically clone test repositories
  - Add `rake integration:test` task to run integration tests
  - Add `rake integration:clean` task to remove cloned repositories
  - Add `rake integration:update` task to update cloned repositories
  - Integration tests verify 99.67% parse success rate across 24,000+ Ruby files
  - Regular unit tests now exclude integration tests for faster execution

## [0.6.1]

### Fixed
- Fix segmentation fault when parsing large Ruby files (e.g., Rails schema.rb)
  - Add `RB_GC_GUARD` for `vast` and `vparser` to prevent garbage collection during AST traversal
  - The AST data is owned by `vast`, so it must remain alive until traversal is complete

## [0.6.0]

### Added
- Add official editor plugins for LSP integration
  - VSCode extension: `vscode-kanayago` available on Visual Studio Marketplace
  - coc.nvim extension: `coc-kanayago` installable via `:CocInstall coc-kanayago`
  - Add screenshots and integration guides to README for both plugins
- Add Emacs integration guide to README
  - Add lsp-mode configuration example for `init.el`
  - Document how to register Kanayago LSP server and enable it for Ruby files
- Add Helix editor integration guide to README
  - Add configuration example for `~/.config/helix/languages.toml`
  - Document how to use Kanayago LSP with Helix editor
- Add Zed editor integration guide to README
  - Add official Zed extension `zed-kanayago` available on Zed Extensions marketplace
  - Document how to install and use Kanayago LSP with Zed editor
  - Add manual installation guide for development purposes
- Add `script_lines` support to parser for accurate line information
  - Enable `rb_ruby_parser_set_script_lines()` in parser to capture source code lines
  - Add `script_lines` attribute to `ParseResult` class
  - Expose script_lines array containing each line of parsed source code
  - Use script_lines for accurate character range calculation in LSP diagnostics

### Fixed
- Fix LSP diagnostics to report accurate error line numbers
  - Update error message pattern matching to support both `main:LINE:` and `(eval):LINE:` formats
  - Remove incorrect `-1` offset that was causing errors to be reported one line above the actual error location
  - Parser already returns 0-based line numbers, matching LSP protocol requirements
  - Clean up error messages by removing redundant `main:LINE:` prefix from diagnostic messages
  - Add comprehensive test cases for error line detection in multi-line source code
- Fix LSP diagnostics not showing underlines in VSCode
  - Use `script_lines` to calculate accurate line length for diagnostic range end position
  - Set proper character range (`end.character`) to display red squiggly lines on entire error line
  - Previously, `start` and `end` positions were identical (both at character 0), preventing underlines from appearing

## [0.5.0]

### Added
- Add LSP (Language Server Protocol) mode
  - `kanayago --lsp` - Start LSP server for editor integration
  - Provides real-time syntax error diagnostics via LSP protocol
  - Supports `textDocument/didOpen`, `didChange`, `didClose` notifications
  - Publishes diagnostics with `textDocument/publishDiagnostics`
  - Compatible with LSP-compliant editors (VSCode, etc.)
  - Add `language_server-protocol` gem dependency (~> 3.17.0)
- Add CLI mode for syntax checking
  - `kanayago check 'code'` - Check Ruby code syntax directly
  - `kanayago check --file FILE` or `-f FILE` - Check syntax of Ruby file
  - Output "Syntax valid" for valid syntax, "Syntax invalid" for invalid syntax
  - Exit with code 0 for valid syntax, 1 for invalid syntax or errors
- Add `ParseResult` class to wrap AST and error information
  - `ParseResult#ast` - Returns the parsed AST (ScopeNode)
  - `ParseResult#error` - Returns SyntaxError object if syntax error occurred, false otherwise
  - `ParseResult#valid?` - Returns true if no syntax error occurred
  - `ParseResult#invalid?` - Returns true if syntax error occurred
  - `Kanayago.parse` now returns `ParseResult` instead of raw AST

### Fixed
- Fix parser crash on syntax errors by implementing `rb_syntax_error_append`
  - Previously, `rb_syntax_error_append` was not available in UniversalParser, causing forced termination when syntax errors occurred during parsing
  - Ported `err_vcatf`, `syntax_error_with_path`, and `rb_syntax_error_append` from Ruby's error.c
  - Added proper copyright notice (Copyright (C) 1993-2007 Yukihiro Matsumoto) as the code is ported from Ruby's error.c
  - Updated patch files for both Ruby 3.4 and head versions
  - Syntax errors now display properly instead of crashing the parser
- Implement error_tolerant mode to continue parsing despite syntax errors
  - Enable `rb_ruby_parser_error_tolerant` flag for all parsing operations
  - Parser now accumulates syntax errors in `error_buffer` instead of terminating
  - Fixed Qfalse handling in `rb_syntax_error_append` (Qfalse is defined as 0, causing `!exc` to evaluate to true)
  - Added OBJ_FROZEN checks to handle frozen default "compile error" messages in SyntaxError objects
  - Both AST and error information are now available even when syntax errors occur

### Changed
- Migrate error_buffer accessor implementation from script to patch files
  - Moved `rb_ruby_parser_error_buffer_get` accessor function from `script/setup_parser.rb` to patch files
  - Added parse.c modifications to both `patch/3.4/kanayago.patch` and `patch/head/kanayago.patch`
  - Improved maintainability and version compatibility by using patch-based approach instead of runtime script modifications
  - Removed `add_error_buffer_accessor` function from `script/setup_parser.rb`
- Update all test files to access AST through `ParseResult#ast`
  - All 93 test files now use `result.ast` instead of direct result access
  - Tests validate both successful parsing and error handling scenarios

## [0.4.1]

### Fixed
- Fix segmentation fault when parsing dynamic symbols in complex hash structures
- Fix segmentation fault when parsing nested modules with outer constant references
- Fix `module_node_new` to use `RNODE_MODULE` instead of incorrect `RNODE_CLASS` macro
- Add NULL pointer checks in `dynamic_string_node_new`, `dynamic_symbol_node_new`, `dynamic_execute_string_node_new`, and `dynamic_regexp_node_new`

### Changed
- Remove incorrect `@super` field access from `ModuleNode` (modules do not have superclasses)

## [0.4.0]

### Added
- Add Ruby class definitions for previously C-only AST nodes:
  - `ScopeNode` - Scope representation with args and body
  - `ClassNode` - Class definition with cpath, super, and body
  - `ModuleNode` - Module definition with cpath, super, and body
  - `DefinitionNode` - Method definition with mid and defn
  - `BeginNode` - Begin statement with body
  - `SelfNode` - Self reference with state
  - `ConstantNode` - Constant reference with vid
  - `OperatorCallNode` - Operator method call with recv, mid, and args
  - `CallNode` - Method call with recv, mid, and args
  - `FunctionCallNode` - Function call with mid and args
  - `VariableCallNode` - Variable call with mid
  - `ArgumentsNode` - Arguments information with ainfo hash
  - `BlockNode` - Block representation (inherits from Array)
  - `ConstantDeclarationNode` - Constant declaration with vid, else, and value
  - `Colon2Node` - Scoped constant resolution (::) with mid and head
  - `Colon3Node` - Top-level constant resolution (::) with mid

### Changed
- Use `rb_intern("@...")` instead of `symbol()` macro for instance variable access in C layer
- Remove redundant getter methods from C layer (scope_node.c and kanayago.c)
- Rely on Ruby's `attr_reader` for attribute access instead of C-defined methods

### Fixed
- Fix SEGV in args_ainfo_tohash function

## [0.3.0] - 2025-10-25

### Fixed
- Fix gem install kanayago

## [0.2.0] - 2025-10-25

### Added
- Add sample for Kanayago usecase
- Support NODE_FOR_MASGN, NODE_MASGN, NODE_DASGN, NODE_ONCE, NODE_ERRINFO, NODE_POSTEXE, and NODE_ERROR
- Support NODE_ARGS_AUX, NODE_OPT_ARG, NODE_KW_ARG, NODE_POSTARG, NODE_ARGSCAT, and NODE_ARGSPUSH
- Support NODE_SPLAT and NODE_BLOCK_PASS
- Support NODE_YIELD and NODE_LAMBDA
- Support NODE_OP_ASGN1, NODE_OP_ASGN2, NODE_OP_ASGN_AND, NODE_OP_ASGN_OR and NODE_OP_CDECL
- Support NODE_NTH_REF and NODE_BACK_REF
- Support NODE_DVAR
- Support NODE_DSYM
- Support NODE_BREAK and NODE_NEXT
- Support NODE_REDO
- Support NODE_DEFINED
- Support NODE_ITER, NODE_RETRY, NODE_RESCUE, NODE_RESBODY and NODE_ENSURE
- Support NODE_HASH, NODE_IN, NODE_ARYPTN, NODE_HSHPTN and NODE_FNDPTN
- Support NODE_MATCH, NODE_MATCH2 and NODE_MATCH3
- Support NODE_REGX and NODE_DREGX
- Support NODE_XSTR and NODE_DXSTR
- Support NODE_FLIP2 and NODE_FLIP3
- Support NODE_DOT2 and NODE_DOT3
- Support NODE_CASE, NODE_CASE2, NODE_CASE3 and NODE_WHEN
- Support NODE_QCALL, NODE_SUPER and NODE_ZSUPER
- Support NODE_DEFS, NODE_SCLASS and NODE_ATTRASGN
- Support NODE_COLON3
- Support NODE_VCALL
- Support NODE_CVASGN
- Support NODE_IASGN
- Support NODE_DSTR and NODE_EVSTR
- Support NODE_GASGN
- Support NODE_RETURN
- Support NODE_UNDEF
- Support NODE_VALIAS
- Support NODE_ALIAS
- Support NODE_FOR
- Support NODE_UNTIL
- Add NODE_WHILE test
- Support NODE_WHILE
- Support NODE_CVAR
- Introduce debug.gem
- Support NODE_MODULE
- Support NODE_SELF
- Support NODE_GVAR
- Support NODE_AND
- Support NODE_OR
- Support NODE_FALSE
- Support NODE_TRUE
- Support NODE_NIL
- Support NODE_ENCODING
- Add typeprof.conf.json
- Support NODE_ZLIST
- Introduce TypeProf for development
- Support __LINE__ literal node
- Support __FILE__ literal node
- Support Ruby 3.4
- Introduce Kanayago gem build and install CI

### Changed
- Update RuboCop
- Split kanayago.patch file to more easier maintain multi Ruby Parser
- Update bin/setup
- Use Node class attr_reader to access Node values
- Split Literal Node code
- Split Kanayago::ScopeNode code
- Update README.md
- Update test CI
- Update kanayago.patch
- Improve import Ruby Parser file's
- Update RuboCop setting
- Migrate to Kanayago parsed AST hash to Instance
- Update kanayago.patch for Ruby head build
- Update CI flow
- Update Kanayago build flow
- Update Ruby Parser's file
- Update lrama
- Split file for Variable Node's
- Move Statement Node class definition
- Rename LeftAssignNode to LocalAssignmentNode

### Fixed
- Fix RuboCop Lint error
- Fix NODE_IF attributes access
- Fix Kanayago::ListNode holds data
- Fix NODE_FOR loop
- Fix Ruby head build failure
- Add internal/namespace.h for Ruby head Parser dependency
- Fix RuboCop SEGV in Ruby head
- Apply auto correct
- Update json
- Update zlib
- Fix CI failures
- Add ext/kanayago/probes.h
- Fix Ruby 3.4 dependency
- Fix Ruby 3.4 build
- Fix file copy error handling
- Fix build gem
- Add dependency for Universal Parser
- Fix code lint

### Removed
- Remove unneeded comment
- Remove Lrama that unneeded any more

### CI
- Add fail-fast: false
- Suppress already initialized constant warning

## [0.1.1] - 2024-09-06

### Changed
- Bump up v0.1.1

## [0.1.0] - 2024-09-06

### Added
- Support NODE_UNLESS
- Add class description
- Add rubocop check in CI
- Add rubocop-on-rbs
- Add rubocop-rake
- Add rubocop and rubocop-minitest for development
- Add refine_tree_parse module function
- Support NODE_IVAR
- Add Referenced implementations link
- Support NODE_SYM
- Support method definition
- Add NODE_CONST test
- Support NODE_CDECL
- Support NODE_CONST
- Support NODE_IF
- Support NODE_LVAR
- Add gdb rake task
- Support NODE_FCALL
- Introduce literal_node_to_hash function for get literal node value
- Support NODE_LASGN
- Add NODE_STR parse test
- Add NODE_IMAGINARY parse test
- Add NODE_RATIONAL parse test
- Add NODE_FLOAT parse test
- Add parse NODE_INTEGER test
- Add GitHub Actions for test
- Add Ruby's Parser files
- Add run task for running test.rb
- Add test for NODE_INTEGER
- Support NODE_CALL
- Support NODE_STR
- Support NODE_IMAGINARY
- Support NODE_BLOCK
- Support NODE_RATIONAL
- Support NODE_FLOAT
- Support NODE_OPCALL and NODE_LIST
- Parse Ruby code and return Hash
- Build Mjollnir with Ruby Parser
- Build ruby-parser for Mjollnir
- Add ruby_parser:build task
- Add lex.c generation for ruby_parser:import task
- Add ruby_parser:clean task
- Add Mjollnir.parse method
- Import ruby parser
- Add lrama
- Add 金屋子 for README.md

### Changed
- Rename parse to kanayago_parse
- Using test-queue
- Auto correct to Gemfile
- Auto correct Hash
- Fix required_ruby_version to > 3.3.0
- Rename to Kanayago
- Ignore refine_tree.gemspec in Metrics/BlockLength
- Format Rakefile
- Rename sig/refine_tree.rb to sig/refine_tree.rbs
- require rubocop-minitest and rubocop-rake
- Generate .rubocop.yml and .rubocop_todo.yml
- Move minitest to test group in Gemfile
- Change to key type from String to Symbol
- Fix require path for test
- Fix install gem name
- Rename to RefineTree
- Fix GitHub Actions
- Add PATH for GitHub Actions
- Add install check for GitHub Actions
- Add depend task for rake build and rake install
- Fix Mjollnir.parse sample in README.md
- Fix username in README.md
- Merge Ruby's Parser struct and enum definition for Mjollnir
- Fix Mjollnir gem summary and description
- Fix gem's description
- Fix README.md
- Fix Mjollnir gem build and install
- Apply RuboCop auto correct to Gemfile
- Apply RuboCop auto correct for test helper
- Apply RuboCop auto correct
- Fix Mjollnir build
- Update TODO's

### Fixed
- Fix SEGV
- Fix NODE_BLOCK support
- Remove allowed_push_host
- Remove parse.c and parse.h
- Ignore parse.c and parse.h
- Fix gem name in GitHub Action

### Removed
- Remove uneeded file
- Remove unnecessary include header
- Remove unnecessary code in Rakefile
- Remove ext/mjollnir/ruby-parser directory
- Remove uneeded headers
- Remove gem build for CI

### Internal
- Suppress warning
- Add newline
- Some refactor for mjollnir.c
- Using rb_ruby_ast_data_get function
