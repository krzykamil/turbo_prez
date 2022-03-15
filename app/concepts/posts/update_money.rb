module Posts
  class UpdateMoney
    class << self
      def call(post_id, money)
        post = Post.find(post_id)
        new_amount = post.revenue + money
        post.update(revenue: new_amount)
      end
    end
  end
end
