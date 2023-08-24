# frozen_string_literal: true

module Slack
  module Socket
    module Api
      module Endpoints
        module Auth
          # Checks authentication & identity.
          #
          # @see https://api.slack.com/methods/auth.test
          # @see https://github.com/slack-ruby/slack-api-ref/blob/master/methods/auth/auth.test.json
          def auth_test(options = {})
            write('auth.test', options)
          end
        end
      end
    end
  end
end
