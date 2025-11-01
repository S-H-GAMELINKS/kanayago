# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
