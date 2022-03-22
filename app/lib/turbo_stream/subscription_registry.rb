module TurboStream
  class SubscriptionRegistry
    TurboRenderHook = Struct.new(:stream_id, :channel, :registered_by, :block) do
      def resolve_actions(args)
        Array(block.call(args))
      end
    end

    def initialize
      @registrations = {}
    end

    def self.instance
      return @instance if @instance

      @instance ||= new
      @instance
    end

    private_class_method :new

    attr_reader :registrations

    def register_new_stream(registered_by, record_class_name, stream_id, channel, block)
      registrations[record_class_name] ||= []

      registrations[record_class_name] << TurboRenderHook.new(
        stream_id, channel, registered_by.to_s, block
      )
    end

    def registered_by(klass)
      klass_name = klass.to_s

      registrations.values.flatten.find { |entry| entry.registered_by == klass_name }
    end
  end
end
