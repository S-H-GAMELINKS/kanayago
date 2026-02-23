# frozen_string_literal: true

require 'language_server-protocol'
require_relative 'diagnostics'

module Kanayago
  module LSP
    # Language Server Protocol server for Kanayago
    class Server
      def initialize(input: $stdin, output: $stdout)
        @input = input
        @output = output
        @writer = LanguageServer::Protocol::Transport::Io::Writer.new(@output)
        @reader = LanguageServer::Protocol::Transport::Io::Reader.new(@input)
        @diagnostics = DiagnosticsProvider.new
        @documents = {} # URI => content mapping
      end

      def start
        @reader.read do |request|
          handle_request(request)
        end
      end

      private

      def handle_request(request)
        case request[:method]
        when 'initialize'
          handle_initialize(request)
        when 'initialized'
          # Client notification, no response needed
        when 'shutdown'
          handle_shutdown(request)
        when 'exit'
          exit(0)
        when 'textDocument/didOpen'
          handle_did_open(request)
        when 'textDocument/didChange'
          handle_did_change(request)
        when 'textDocument/didClose'
          handle_did_close(request)
        else
          # Unsupported method
          send_response(request[:id], nil) if request[:id]
        end
      end

      def handle_initialize(request)
        result = {
          capabilities: {
            textDocumentSync: {
              openClose: true,
              change: LanguageServer::Protocol::Constant::TextDocumentSyncKind::FULL
            }
          },
          serverInfo: {
            name: 'Kanayago LSP',
            version: Kanayago::VERSION
          }
        }
        send_response(request[:id], result)
      end

      def handle_shutdown(request)
        send_response(request[:id], nil)
      end

      def handle_did_open(request)
        params = request[:params]
        uri = params[:textDocument][:uri]
        text = params[:textDocument][:text]

        @documents[uri] = text
        publish_diagnostics(uri, text)
      end

      def handle_did_change(request)
        params = request[:params]
        uri = params[:textDocument][:uri]

        # FULL sync: get entire content
        text = params[:contentChanges][0][:text]

        @documents[uri] = text
        publish_diagnostics(uri, text)
      end

      def handle_did_close(request)
        params = request[:params]
        uri = params[:textDocument][:uri]

        @documents.delete(uri)
        # Clear diagnostics
        publish_diagnostics(uri, nil)
      end

      def publish_diagnostics(uri, text)
        diagnostics = text ? @diagnostics.analyze(text) : []

        notification = {
          method: 'textDocument/publishDiagnostics',
          params: {
            uri: uri,
            diagnostics: diagnostics
          }
        }

        send_notification(notification)
      end

      def send_response(id, result)
        response = {
          jsonrpc: '2.0',
          id: id,
          result: result
        }
        @writer.write(response)
      end

      def send_notification(notification)
        message = {
          jsonrpc: '2.0',
          method: notification[:method],
          params: notification[:params]
        }
        @writer.write(message)
      end
    end
  end
end
