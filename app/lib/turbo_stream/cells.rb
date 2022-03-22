module TurboStream
  module Cells
    ActionsParams = Struct.new(:context, :model, :updates, keyword_init: true)

    class << self
      include ::Turbo::StreamsHelper
      REGISTRY = ::TurboStream::SubscriptionRegistry.instance

      def register(registered_by, record, stream_id, channel, block)
        REGISTRY.register_new_stream(registered_by.to_s, record.to_s, stream_id, channel, block)
      end

      def render_for(record, updates: {})
        registry_entry_id = record.is_a?(Array) ? record.first : record
        registrations[registry_entry_id.class.to_s].each do |render_hook|
          next unless stream_active?(render_hook.stream_id)

          channel = render_hook.channel.constantize
          streamables = stream_handler.stream_name(stream_id: render_hook.stream_id)

          actions_params = ActionsParams.new(
            context: { controller: controller },
            model: record,
            updates: updates
          )
          actions = render_hook.resolve_actions(actions_params)

          Array(actions).each do |action|
            broadcast_action(streamables, channel: channel, action: action)
          end
        end
      end

      def registrations
        REGISTRY.registrations
      end

      def registered_by(...)
        REGISTRY.registered_by(...)
      end

      private

      def stream_handler
        @stream_handler ||= TurboStream::StreamsHandler
      end

      def stream_active?(stream_id)
        stream_handler.live_stream_is_present?(stream_id: stream_id)
      end

      # Some nasty stuff connected to rails needing to have controller context to generate path
      def controller
        url_settings = {:host=>"localhost", :port=>3000}
        request = ActionDispatch::Request.new(url_settings)
        instance = ApplicationController.new
        instance.set_request! request
      end

      def broadcast_action(streamables, channel:, action:)
        case action
          when TurboStream::Actions::Update
            channel.broadcast_update_to(streamables, target: action.target, html: action.html)
          when TurboStream::Actions::Append
            channel.broadcast_append_to(streamables, target: action.target, html: action.html)
          when TurboStream::Actions::Remove
            channel.broadcast_remove_to(streamables, target: action.target)
        end
      end
    end
  end
end
