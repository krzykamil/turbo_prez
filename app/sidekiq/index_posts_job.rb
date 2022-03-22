class IndexPostsJob
  include Sidekiq::Job

  def perform
    posts = Post.all.sample(7).shuffle
    ::TurboStream::Cells.render_for(posts, updates: { posts: posts })
  end
end

