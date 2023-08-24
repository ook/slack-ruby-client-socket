# frozen_string_literal: true

require 'async/http/internet'
require 'async/http/endpoint'
require 'async/websocket/client'

module Slack
  module Socket
    class Client
      include Api::Options
      include Api::Endpoints

      def slack_socket_url(debug: false)
        @slack_socket_url ||= begin
          Async do
            client = Async::HTTP::Internet.new
            response = client.post('https://slack.com/api/apps.connections.open',
                                   [['accept', 'application/json'], ['authorization', "Bearer #{Slack::Config.token}"]])
            @slack_socket_url = JSON.parse(response.read)['url']
            @slack_socket_url += '#&debug_reconnects=true' if debug
          ensure
            client.close
          end
          pp @slack_socket_url
          @slack_socket_url
        end
      end

      def connect!(handler, auto_acknowledge: true, debug: false)
        # Should put a trap on sig INT to stop this loop
        loop do
          endpoint = Async::HTTP::Endpoint.parse(slack_socket_url)

          Async do
            Async::WebSocket::Client.connect(endpoint) do |socket|
              @socket = socket
              handler.on_connection

              while (message = socket.read)
                message = JSON.parse(message.buffer)
                if auto_acknowledge
                  next unless message['envelope_id']

                  # Acknowledge receipt of message
                  # https://api.slack.com/apis/connections/socket-implement#acknowledge
                  socket.write({ envelope_id: message['envelope_id'] }.to_json)
                  socket.flush
                else
                  puts 'NO ACK'
                end

                case message['type']
                when 'hello'
                  handler.on_hello(message)
                when 'disconnect'
                  handler.on_disconnect(message)
                when 'events_api'
                  handler.on_events_api(message)
                else
                  pp message
                  raise "Unknown: #{message['type']}"
                end
              end
            rescue EOFError
              puts 'Got kicked out of the connection. Search to get back on horse'
            end
          end
        end
      end

      def write(call, options = {})
        raise 'No current socket connect' if @socket.nil?

        payload = { type: call }
        options.delete(:type)
        options.each do |(k, v)|
          payload[k] = v
        end
        pp payload
        puts payload.to_json
        @socket.write(payload.to_json)
        @socket.flush
      end
    end
  end
end
