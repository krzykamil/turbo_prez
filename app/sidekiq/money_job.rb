class MoneyJob
  include Sidekiq::Job

  def perform(post_id, money)
    Posts::UpdateMoney.call(post_id, money)
  end
end

