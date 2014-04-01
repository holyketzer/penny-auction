set :application, 'penny-auction'
set :repository,  'git@github.com:holyketzer/penny-auction.git'

require 'bundler/capistrano'
require 'rvm/capistrano'

load 'deploy/assets'

set :port, 40404
set :use_sudo, false
set :rails_env, :production
set :branch, 'master'
set :deploy_to, '/home/deployer/rails/penny-auction'
set :user, 'deployer'

role :web, '188.226.199.9'                   # Your HTTP server, Apache/etc
role :app, '188.226.199.9'                   # This may be the same as your `Web` server
role :db,  '188.226.199.9', primary: true # This is where Rails migrations will run

set :bundle_cmd, '/home/deployer/.rvm/gems/ruby-2.0.0-p451@global/bin/bundle'
set :bundle_dir, '/home/deployer/.rvm/gems/ruby-2.0.0-p451'
set :rvm_ruby_string, 'ruby-2.0.0-p451@global'
set :rvm_type, :user

set :stage, rails_env

before 'deploy:assets:precompile', roles: :app do
  run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
  run "ln -nfs #{shared_path}/application.yml #{release_path}/config/application.yml"
  run "ln -nfs #{shared_path}/private_pub.yml #{release_path}/config/private_pub.yml"
  run "ln -nfs #{shared_path}/private_pub_thin.yml #{release_path}/config/private_pub_thin.yml"
  run "rm -rf #{release_path}/public/uploads"
  run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
end
before 'deploy:assets:precompile', 'deploy:migrate'
after 'deploy:migrate', 'deploy:seed'
after 'deploy:restart', 'deploy:cleanup'
after 'deploy:restart', 'private_pub:restart'

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, roles: :app, except: { no_release: true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :seed, roles: :app do
    run "cd #{current_path} && #{bundle_cmd} exec rake RAILS_ENV=#{rails_env} db:seed"
  end
end

namespace :private_pub do
  desc 'Start private_pub server'
  task :start, roles: :app do
    run "cd #{current_path};RAILS_ENV=#{rails_env} bundle exec thin -C config/private_pub_thin.yml start"
  end

  desc 'Stop private_pub server'
  task :stop, roles: :app do
    run "cd #{current_path};RAILS_ENV=#{rails_env} bundle exec thin -C config/private_pub_thin.yml stop"
  end

  desc "Restart private_pub server"
  task :restart, :roles => :app do
    run "cd #{current_path};RAILS_ENV=#{rails_env} bundle exec thin -C config/private_pub_thin.yml restart"
  end
end

