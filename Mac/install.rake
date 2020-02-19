namespace :preload do
  desc "Copies all migrations and assets (NOTE: This will be obsolete with Rails 3.1)"
  task :import do
    Rake::Task['preload:install:import'].invoke
  end

  namespace :install do

    desc "Loads data into the store"
    task :import do   # an invoke will not execute the task after defaults has already executed it
      Rake::Task['db:load_dir'].reenable
      Rake::Task["db:load_dir"].invoke( "data" )
      puts "Data has been loaded"
    end

  end
  
end