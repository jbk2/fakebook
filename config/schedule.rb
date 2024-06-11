# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
# Learn more: http://github.com/javan/whenever

set :output, "#{path}/log/cron_log.log"

# Purge orphaned blobs on the 1st day of each month at midnight
every '0 0 1 * *' do
  rake "cleanup:purge_orphaned_blobs"
end

# Clear tmp/capybara directory on the 1st day of each month at 12:05 AM
every '5 0 1 * *' do
  rake "tmp:clear_capybara"
end

# Clear tmp/storage directory on the 1st day of each month at 12:10 AM
every '10 0 1 * *' do
  rake "tmp:clear_storage"
end

# Clear general tmp directory on the 1st day of each month at 12:15 AM
every '15 0 1 * *' do
  rake "tmp:clear"
end