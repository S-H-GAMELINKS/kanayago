# frozen_string_literal: true

require_relative '../../test_helper'
require 'stringio'
require 'json'

class LSPServerTest < Minitest::Test
  def setup
    @input = StringIO.new
    @output = StringIO.new
    @server = Kanayago::LSP::Server.new(input: @input, output: @output)
  end

  def test_initialize_request
    request = {
      jsonrpc: '2.0',
      id: 1,
      method: 'initialize',
      params: {
        capabilities: {}
      }
    }

    # Handle request manually
    @server.send(:handle_request, request)

    # Check output
    @output.rewind
    response_header = @output.read

    assert_match(/Content-Length:/, response_header)
  end

  def test_shutdown_request
    request = {
      jsonrpc: '2.0',
      id: 2,
      method: 'shutdown'
    }

    @server.send(:handle_request, request)

    @output.rewind
    response_header = @output.read

    assert_match(/Content-Length:/, response_header)
  end

  def test_did_open_notification
    request = {
      jsonrpc: '2.0',
      method: 'textDocument/didOpen',
      params: {
        textDocument: {
          uri: 'file:///test.rb',
          text: 'def foo; end'
        }
      }
    }

    @server.send(:handle_request, request)

    @output.rewind
    response = @output.read

    # Should publish diagnostics
    assert_match(%r{textDocument/publishDiagnostics}, response)
  end

  def test_did_change_notification
    # First open the document
    open_request = {
      jsonrpc: '2.0',
      method: 'textDocument/didOpen',
      params: {
        textDocument: {
          uri: 'file:///test.rb',
          text: 'def foo; end'
        }
      }
    }

    @server.send(:handle_request, open_request)
    @output.truncate(0)
    @output.rewind

    # Then change it
    change_request = {
      jsonrpc: '2.0',
      method: 'textDocument/didChange',
      params: {
        textDocument: {
          uri: 'file:///test.rb'
        },
        contentChanges: [
          { text: 'def bar; end' }
        ]
      }
    }

    @server.send(:handle_request, change_request)

    @output.rewind
    response = @output.read

    # Should publish diagnostics again
    assert_match(%r{textDocument/publishDiagnostics}, response)
  end

  def test_did_close_notification
    # First open the document
    open_request = {
      jsonrpc: '2.0',
      method: 'textDocument/didOpen',
      params: {
        textDocument: {
          uri: 'file:///test.rb',
          text: 'def foo; end'
        }
      }
    }

    @server.send(:handle_request, open_request)
    @output.truncate(0)
    @output.rewind

    # Then close it
    close_request = {
      jsonrpc: '2.0',
      method: 'textDocument/didClose',
      params: {
        textDocument: {
          uri: 'file:///test.rb'
        }
      }
    }

    @server.send(:handle_request, close_request)

    @output.rewind
    response = @output.read

    # Should publish empty diagnostics
    assert_match(%r{textDocument/publishDiagnostics}, response)
  end
end
