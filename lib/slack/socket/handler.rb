# frozen_string_literal: true

module Slack
  module Socket
    class Handler
      attr_reader :client, :got_disconnected

      def initialize(client)
        @client = client
      end

      def on_hello(message)
        puts 'HANDLER ONHELLO'
        pp message
        puts "#{DateTime.now.strftime('%Y%m%d-%H:%M:%S')} Connection will restart in #{message.dig('debug_info',
                                                                                                   'approximate_connection_time')}s"
      end

      def on_disconnect(message)
        puts 'HANDLER on_disconnect'
        pp message
        case message['reason']
        when 'warning'
          puts "#{DateTime.now.strftime('%Y%m%d-%H:%M:%S')} Warning: connection disconnection by slack in seconds"
        when 'refresh_requested'
          puts "#{DateTime.now.strftime('%Y%m%d-%H:%M:%S')} Slack request immediate disconnection"
          @got_disconnected = true
        else
          raise "Unsupported message: #{message.inspect}"
        end
      end

      def on_connection
        puts 'HANDLER ON CONNECTION'
        if @got_disconnected
          # release disconnection
          @got_disconnected = false
          puts 'Come from a disconnection, skipping'
          return
        end
        client.auth_test
        client.chat_postMessage(channel: '#agent-smith', text: 'Hello World', as_user: true)
      end

      def on_events_api(_message)
        puts 'HANDLER on EVENTS_API'
      end
    end
  end
end
