# Use this file to easily define all of your cron jobs.

# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
set :output, "log/cron.log"
set :environment, "development"

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
every 1.minute do
  runner "InteractionsConsumer.consume"
  runner "InteractionsGenerator.generate"
end
#

# Learn more: http://github.com/javan/whenever
