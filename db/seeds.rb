User.create(email: "author@email.com", name: "Admin Author")
User.create(email: "guy@email.com", name: "Some Guy")
5.times do |_|
  content = 5.times.with_object([]) { |_, arr| arr << Faker::TvShows::TwinPeaks.quote }.join("\n")
  amount = rand(100.100000)
  content += "\n I made this much money in this week #{amount} \n"
  content += 5.times.with_object([]) { |_, arr| arr << Faker::Movies::Lebowski.quote }.join("\n")
  Post.create(content: content, revenue: amount, user: User.find_by_email('author@email.com'))
end
