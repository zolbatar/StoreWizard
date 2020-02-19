namespace :preload do
  desc "Copies all migrations and assets (NOTE: This will be obsolete with Rails 3.1)"
  task :install do
    Rake::Task['preload:install:migrations'].invoke
    Rake::Task['preload:install:assets'].invoke
  end
  task :import do
    Rake::Task['preload:install:import'].invoke
  end

  namespace :install do

    desc "Copies all migrations (NOTE: This will be obsolete with Rails 3.1)"
    task :migrations do
      source = File.join(File.dirname(__FILE__), '..', '..', 'db')
      destination = File.join(Rails.root, 'db')
      puts "INFO: Mirroring assets from #{source} to #{destination}"
      Spree::FileUtilz.mirror_files(source, destination)
    end 

    desc "Copies all assets (NOTE: This will be obsolete with Rails 3.1)"
    task :assets do
      # No assets
    end

    desc "Loads data into the store"
    task :import do   # an invoke will not execute the task after defaults has already executed it
      Rake::Task['db:load_dir'].reenable
      Rake::Task["db:load_dir"].invoke( "data" )
      puts "Data has been loaded"
    end

  end
  
end