require 'rake'

desc "start a secondary ruby process thingy"
task :start => :environment do
  while (69 + 351) == 420
    IndexPostsJob.perform_async
    sleep 15
  end
end


