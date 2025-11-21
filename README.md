# Kanayago(金屋子)

Trying to Make Ruby's Parser Available as a Gem.

## Support Ruby version

Kanayago(金屋子)　is supported Ruby 3.4 or Ruby head.

## Installation
### From RubyGems

```
gem install kanayago
```

### Build and Install in local

First, clone this repository.

```console
git clone https://github.com/S-H-GAMELINKS/kanayago.git
```

Move `kanayago` directory, and run `bundle install`.

```console
cd kanayago && bundle install
```

Finally, build `Kanayago` gem  and install it.

```console
bundle exec rake build
gem install pkg/kanayago-0.5.0.gem
```

## Usage

### Language Server Protocol (LSP) Mode

Kanayago provides LSP server support for real-time syntax checking in your editor:

```bash
# Start LSP server
$ kanayago --lsp
```

This starts an LSP server that communicates via stdin/stdout. You can integrate it with LSP-compliant editors like VSCode, Vim, Emacs, etc.

#### VSCode Integration Example

Create or modify `.vscode/settings.json`:

```json
{
  "ruby.lsp.enabled": false,
  "ruby.languageServer": "kanayago-lsp",
  "ruby.languageServerPath": "kanayago",
  "ruby.languageServerArgs": ["--lsp"]
}
```

Now VSCode will show syntax errors in real-time as you type Ruby code.

#### Vim/Neovim with coc.nvim Integration Example

Add the following to your `coc-settings.json` (`:CocConfig` in Vim):

```json
{
  "languageserver": {
    "kanayago": {
      "command": "kanayago",
      "args": ["--lsp"],
      "filetypes": ["ruby"],
      "rootPatterns": ["Gemfile", ".git"]
    }
  }
}
```

Now Vim/Neovim with coc.nvim will show syntax errors in real-time as you edit Ruby files.

### Command Line Interface

Kanayago provides a CLI for syntax checking:

```bash
# Check Ruby code directly
$ kanayago check 'p 117'
Syntax valid

# Check Ruby code with syntax error
$ kanayago check 'def foo'
Syntax invalid

# Check a Ruby file
$ kanayago check --file test.rb
Syntax valid

# Or use the short option
$ kanayago check -f test.rb
Syntax valid
```

The CLI exits with code 0 for valid syntax and code 1 for invalid syntax or errors.

### Ruby API

```ruby
require 'kanayago/kanayago'

result = Kanayago.parse('117 + 117')
# => #<Kanayago::ParseResult:0x00007f522199c5a8>

p result.ast
# => #<Kanayago::ScopeNode:0x00007f522199c5a8>

p result.ast.body
# => #<Kanayago::OperatorCallNode:0x00007f5221b06358>

p result.ast.body.recv
p result.ast.body.recv.val
# => #<Kanayago::IntegerNode:0x00007f5221b06330>
# => 117

# Check for syntax errors
result = Kanayago.parse('def foo')
p result.valid?
# => false
p result.error
# => #<SyntaxError: syntax error, unexpected end-of-input>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/S-H-GAMELINKS/kanayago.

## Referenced implementations

[yui-knk/ruby-parser](https://github.com/yui-knk/ruby-parser)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
