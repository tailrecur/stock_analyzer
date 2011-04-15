namespace :worker do
  desc "Start n workers"
  task :start do
    no_of_workers = ENV["NUMBER"] || 3
    no_of_workers.to_i.times do
      fork do
        exec("rake jobs:work  2>&1")
      end
    end
    puts "Started #{no_of_workers} workers"
  end
end


