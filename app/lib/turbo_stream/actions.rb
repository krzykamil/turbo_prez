module TurboStream
  module Actions
    class BaseAction
      attr_reader :target

      def initialize(raw_html = nil, target:)
        @raw_html = raw_html
        @target = target
      end

      def html
        @html ||= @raw_html.is_a?(Proc) ? @raw_html.call : @raw_html
      end
    end

    class Remove < BaseAction; end
    class Append < BaseAction; end
    class Update < BaseAction; end
  end
end
