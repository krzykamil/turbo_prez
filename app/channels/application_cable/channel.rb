module ApplicationCable
  class Channel < ActionCable::Channel::Base
    extend Turbo::Streams::StreamName
    extend Turbo::Streams::Broadcasts
    include Turbo::Streams::StreamName::ClassMethods

    periodically :check_stream_activity, every: 15.seconds

    def subscribed
      puts "CHANNEL"
      TurboStream::StreamsHandler.add_stream(signed_stream_name: params["signed_stream_name"])
      stream_from params["signed_stream_name"]
    end

    private

    def check_stream_activity
      actual_streams = ActionCable.server.pubsub.send(:redis_connection).pubsub('channels')
      our_streams = TurboStream::StreamsHandler.active_streams

      inactive_streams = our_streams.reject do |stream|
        actual_streams.include?(stream.signed_stream_name)
      end

      inactive_streams.each do |inactive_stream|
        stop_stream_from inactive_stream.signed_stream_name
        TurboStream::StreamsHandler.remove_stream(
          signed_stream_name: inactive_stream.signed_stream_name
        )
      end
    end
  end
end
