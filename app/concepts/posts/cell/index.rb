module Posts
  module Cell
    class Index < ::Trailblazer::Cell
      include ::Cell::TurboStream
      alias posts model

      register_turbo_rendering(Post) do |params|
        instance = new(params.model, context: params.context)
        html = -> { instance.(:turbo) }
        TurboStream::Actions::Update.new(html, target: instance.target_id)
      end

    end
  end
end
