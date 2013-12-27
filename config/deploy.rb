require 'rvm/capistrano' # Для работы rvm
require 'bundler/capistrano' # Для работы bundler. При изменении гемов bundler автоматически обновит все гемы на сервере, чтобы они в точности соответствовали гемам разработчика.
require 'puma/capistrano'


set :application, "littlechief"
set :site_domain, "littlechief.kerweb.ru.ru"
set :rails_env, "production"
set :domain, "mkonin@185.4.75.151"
set :deploy_to, "/var/www/#{application}"
set :use_sudo, false
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"
set :normalize_asset_timestamps, false
set :keep_releases, 5

set :rvm_ruby_string, '2.0.0-p353'

set :scm, :git
set :repository,  "https://github.com/KernelCorp/littlechief.git"
set :branch, "master" # Ветка из которой будем тянуть код для деплоя.
set :deploy_via, :remote_cache # Указание на то, что стоит хранить кеш репозитария локально и с каждым деплоем лишь подтягивать произведенные изменения. Очень актуально для больших и тяжелых репозитариев.

role :web, domain
role :app, domain
role :db,  domain, :primary => true

before 'deploy:setup', 'rvm:install_rvm', 'rvm:install_ruby'



after "deploy", "deploy:migrate"
after "deploy:update", "deploy:cleanup"

after 'deploy:finalize_update', :roles => :app do
  # Здесь для примера вставлен только один конфиг с приватными данными - database.yml. Обычно для таких вещей создают папку /srv/myapp/shared/config и кладут файлы туда. При каждом деплое создаются ссылки на них в нужные места приложения.
  run "rm -f #{current_release}/config/database.yml"
  run "ln -s #{current_release}/config/database.yml.example #{current_release}/config/database.yml"
end

namespace :deploy do
  task :init_vhost do
    run "ln -s #{deploy_to}/current/config/#{application}.vhost /etc/nginx/sites-enabled/#{application}"
  end
end