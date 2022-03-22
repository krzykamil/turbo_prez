module Cell
  module TurboStream
    DEFAULT_CHANNEL = 'ApplicationCable::Channel'.freeze
    include ::Turbo::IncludesHelper
    include ::Turbo::StreamsHelper

    def self.included(base)
      base.send :extend, ClassMethods
    end

    def turbo
      turbo_show = content_tag(:div, id: target_id) do
        show
      end
      [turbo_stream_tag, turbo_show].join.html_safe
    end

    def turbo_stream_tag
      # This can be used to create unique stream ids, for when you get actual users in the app for example
      # You could incorporate their id into the streamables hash, so that you could decipher it later
      # and serve a stream only for them
      # TODO: actually add users as an example
      turbo_stream_from(
        { stream_id: self.class.base_stream_id }, channel: self.class.channel_name
      )
    end

    # If you want to extend the target_id to be unique (again, to be used for when different users see different, personal content)
    # this method would have to be expanded. Proposed solution is commented
    def target_id
      self.class.name.to_s.underscore.gsub(%r{/|_}, '-')

      # id = [self.class.name.to_s.underscore.gsub(%r{/|_}, "-")]
      # id << model.id if model.respond_to?(:id)
      #
      # id.join('-')
    end

    module ClassMethods
      @channel = nil
      def register_turbo_rendering(record, &block)
        ::TurboStream::Cells.register(self, record, base_stream_id, channel_name, block)
      end

      # The channel stuff in here and turbo_stream_tag, exist to give cells possibilities to connect to different channels
      # This can be useful for when you want completely different view context for some cells, where for example, some
      # channels serve for different types of users, like non logged in users etc.
      def channel(name)
        @channel = name
      end

      def channel_name
        @channel || DEFAULT_CHANNEL
      end

      def base_stream_id
        @existing_turbo_stream || name.to_s.underscore.gsub(%r{/|_}, '-')
      end
    end
  end
end
