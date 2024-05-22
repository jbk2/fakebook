# lib/tasks/cleanup.rake
namespace :cleanup do
  desc 'Purge orphaned Active Storage blobs'
  task purge_orphaned_blobs: :environment do
    begin
      # Purge blobs not attached to any records
      orphans = ActiveStorage::Blob.left_outer_joins(:attachments).where(active_storage_attachments: { id: nil })
      orphans.find_each do |blob|
        puts "Purging orphaned blob #{blob.id}"
        blob.purge
      end
      puts "Purged #{orpans.size} orphaned blobs."
    rescue => e
      puts "There was an error purging orphaned jobs; #{e.message}"
    end
  end
end

namespace :tmp do
  desc 'Clear tmp/capybara directory'
  task clear_capybara: :environment do
    begin
      puts "Clearing tmp/capybara directory..."
      FileUtils.rm_rf(Dir.glob(Rails.root.join('tmp', 'capybara', '*')))
      puts "tmp/capybara directory cleared."
    rescue => e
      puts "Error clearing tmp/capybara directory: #{e.message}"
    end
  end
  
  desc 'Clearup tmp/storage directory'
  task clear_storage: :environment do
    begin
      puts "Clearing tmp/storage directory..."
      FileUtils.rm_rf(Dir.glob(Rails.root.join('tmp', 'storage', '*')))
      puts "tmp/storage directory cleared."
    rescue => e
      puts "Error clearing tmp/storage directory: #{e.message}"
    end
  end
end


namespace :db do
  desc "Clear the storage directory & reset the database"
  task clear_storage_and_reset: :environment do
    begin
      puts "Clearing tmp/storage directory..."
      FileUtils.rm_rf(Dir.glob(Rails.root.join('tmp', 'storage', '*')))
      puts "tmp/storage directory cleared."
    rescue => e
      puts "Error clearing tmp/storage directory: #{e.message}"
    end

    begin
      puts "Clearing /storage directory..."
      FileUtils.rm_rf(Dir.glob(Rails.root.join('storage', '*')))
      puts "Storage directory cleared."
    rescue => e
      puts "Error clearing storage directory: #{e.message}"
    end

    begin
      Rake::Task["db:reset"].invoke
    rescue => e
      puts "Error resetting database: #{e.message}"
    end
  end
end