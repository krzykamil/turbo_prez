module TurboStream
  module StreamsHandler
    Stream = Struct.new(:stream_id, :signed_stream_name)
    REDIS_SET_NAME = "streams".freeze

    class << self
      def add_stream(signed_stream_name:)
        redis.sadd(REDIS_SET_NAME, signed_stream_name)
        signed_stream_name
      end

      def remove_stream(signed_stream_name:)
        redis.srem(REDIS_SET_NAME, signed_stream_name)
      end

      def stream_name(stream_id:)
        active_streams.find { |stream| stream.stream_id == stream_id }&.signed_stream_name
      end

      def active_streams
        streams.map.with_object([]) do |stream_signed, decoded|
          original_hash = decoded_signed_stream(stream_signed)
          next if original_hash.nil?

          decoded << Stream.new(original_hash[:stream_id], stream_signed)
        end
      end

      def live_stream_is_present?(stream_id:)
        active_streams.any? { |stream| stream.stream_id == stream_id }
      end

      private

      def redis
        @redis ||= Redis.current
      end

      def streams
        redis.smembers(REDIS_SET_NAME)
      end

      def decoded_signed_stream(stream_signed)
        decoded_string = Turbo.signed_stream_verifier.verified(stream_signed)
        return if decoded_string.nil?

        Hash[*decoded_string.gsub(/&|=/, ',').split(',')].symbolize_keys
      end
    end
  end
end
