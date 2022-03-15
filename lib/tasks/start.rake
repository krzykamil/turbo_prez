require 'rake'

desc "start a secondary ruby process thingy"
task :start => :environment do
  while (69 + 351) == 420
    Post.find_each do |post|
      MoneyJob.perform_async(post.id, rand(1000..42069))
      sleep 5
    end
  end
end


