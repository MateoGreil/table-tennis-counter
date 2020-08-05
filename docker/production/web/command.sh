rm -f /app/tmp/pids/server.pid
bundle install
RAILS_ENV=production rails s -b 0.0.0.0
