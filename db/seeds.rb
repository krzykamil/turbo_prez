User.create(email: "author@email.com", name: "Admin Author")
User.create(email: "guy@email.com", name: "Some Guy")
7.times do |_|
  content = 5.times.with_object([]) { |_, arr| arr << Faker::TvShows::TwinPeaks.quote }.join("\n")
  amount = rand(100..100000)
  Post.create(
    image_link: Faker::Company.logo,
    content: content,
    revenue: amount,
    user: User.find_by_email('author@email.com')
  )
end

