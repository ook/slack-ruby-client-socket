# frozen_string_literal: true

require_relative 'endpoints/auth'
require_relative 'endpoints/chat'

module Slack
  module Socket
    module Api
      module Endpoints
        include Auth
        include Chat
      end
    end
  end
end
