# frozen_string_literal: true

module Slack
  module Socket
    module Api
      module Endpoints
        module Chat
          #
          # Sends a message to a channel.
          #
          # @option options [channel] :channel
          #   Channel, private group, or IM channel to send message to. Can be an encoded ID, or a name. See below for
          #   more details.
          # @option options [string] :attachments
          #   A JSON-based array of structured attachments, presented as a URL-encoded string.
          # @option options [blocks[] as string] :blocks
          #   A JSON-based array of structured blocks, presented as a URL-encoded string.
          # @option options [string] :text
          #   The formatted text of the message to be published. If blocks are included, this will become the fallback
          #   text used in notifications.
          # @option options [boolean] :as_user
          #   (Legacy) Pass true to post the message as the authed user instead of as a bot. Defaults to false.
          #   Can only be used by classic Slack apps. See authorship below.
          # @option options [string] :icon_emoji
          #   Emoji to use as the icon for this message. Overrides icon_url.
          # @option options [string] :icon_url
          #   URL to an image to use as the icon for this message.
          # @option options [boolean] :link_names
          #   Find and link user groups. No longer supports linking individual users; use syntax shown in Mentioning
          #   Users instead.
          # @option options [string] :metadata
          #   JSON object with event_type and event_payload fields, presented as a URL-encoded string. Metadata you
          #   post to Slack is accessible to any app or user who is a member of that workspace.
          # @option options [boolean] :mrkdwn
          #   Disable Slack markup parsing by setting to false. Enabled by default.
          # @option options [string] :parse
          #   Change how messages are treated. See below.
          # @option options [boolean] :reply_broadcast
          #   Used in conjunction with thread_ts and indicates whether reply should be made visible to everyone in the
          #   channel or conversation. Defaults to false.
          # @option options [string] :thread_ts
          #   Provide another message's ts value to make this message a reply. Avoid using a reply's ts value; use its
          #   parent instead.
          # @option options [boolean] :unfurl_links
          #   Pass true to enable unfurling of primarily text-based content.
          # @option options [boolean] :unfurl_media
          #   Pass false to disable unfurling of media content.
          # @option options [string] :username
          #   Set your bot's user name.
          # @see https://api.slack.com/methods/chat.postMessage
          # @see https://github.com/slack-ruby/slack-api-ref/blob/master/methods/chat/chat.postMessage.json
          def chat_postMessage(options = {})
            raise ArgumentError, 'Required arguments :channel missing' if options[:channel].nil?

            if options[:attachments].nil? && options[:blocks].nil? && options[:text].nil?
              raise ArgumentError,
                    'At least one of :attachments, :blocks, :text is required'
            end

            options = encode_options_as_json(options, %i[attachments blocks metadata])
            write('chat.postMessage', options)
          end
        end
      end
    end
  end
end
