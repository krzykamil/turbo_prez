module Posts
  module Cell
    class Exposed < Trailblazer::Cell
      alias post model
    end
  end
end
