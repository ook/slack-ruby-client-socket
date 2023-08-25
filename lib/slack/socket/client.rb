# frozen_string_literal: true

require 'async/http/internet'
require 'async/http/endpoint'
require 'async/websocket/client'

module Slack
  module Socket
    class Client
      include Api::Options
      include Api::Endpoints

      def initialize(debug: false)
        @debug = debug
      end

      def connect!(handler, auto_acknowledge: true)
        # Should put a trap on sig INT to stop this loop
        loop do
          Async do
            Async::WebSocket::Client.connect(endpoint) do |socket|
              @socket = socket
              handler.on_connection

              while (message = socket.read)
                message = JSON.parse(message.buffer)
                acknowledge_message(message['envelope_id']) if auto_acknowledge

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

      private

      def acknowledge_message(envelope_id)
        return if envelope_id.nil?

        # Acknowledge receipt of message
        # https://api.slack.com/apis/connections/socket-implement#acknowledge
        socket.write({ envelope_id: envelope_id }.to_json)
        socket.flush
      end

      def endpoint
        Async::HTTP::Endpoint.parse(slack_socket_url(debug: @debug))
      end

      def slack_socket_url(debug: false)
        url = nil
        Async do
          client = Async::HTTP::Internet.new
          response = client.post('https://slack.com/api/apps.connections.open',
                                 [['accept', 'application/json'], ['authorization', "Bearer #{Slack::Config.token}"]])
          url = JSON.parse(response.read)['url']
        ensure
          client.close
        end
        debug ? "#{url}&debug_reconnects=true" : url
      end
    end
  end
end
