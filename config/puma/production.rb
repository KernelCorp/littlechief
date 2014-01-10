app_path = '/var/www/littlechief'
threads 1, 8
workers 2
environment 'production'
pidfile "#{app_path}/shared/pids/puma.pid"
bind "unix://#{app_path}/shared/sockets/puma.sock"

on_worker_boot do
  require "active_record"
  cwd = File.dirname(__FILE__) + "/.."
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"] || YAML.load_file("#{cwd}/config/database.yml")[ENV["RAILS_ENV"]])
end