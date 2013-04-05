# Multistage
require 'capistrano/ext/multistage'
# Load bundler-capistrano gem
require "bundler/capistrano"
# Load rvm-capistrano gem
require "rvm/capistrano"
# Include New Relic recipes
#require 'new_relic/recipes'

set :ssh_options, {:forward_agent => true}
set :app_title, "findingaids"
set :application, "#{app_title}_repos"

# RVM  vars
set :rvm_ruby_string, "1.9.3-p125"
set :rvm_type, :user

# Bundle vars
set :bundle_without, [:development, :test]

# Git vars
set :repository, "git@github.com:NYULibraries/findingaids.git" 
set :scm, :git
set :deploy_via, :remote_cache
set(:branch, 'master') unless exists?(:branch)
set :git_enable_submodules, 1

# Environments
set :stages, ["staging", "production"]
set :default_stage, "staging"
set :keep_releases, 5
set :use_sudo, false

# Configure app_settings from rails_config
# Defer processing until we have rails environment
set(:app_settings) { eval(run_locally("rails runner -e #{rails_env} 'p Settings.capistrano.to_hash'")) }
set(:scm_username) { app_settings[:scm_username] }
set(:app_path) { app_settings[:path] }
set(:user) { app_settings[:user] }
set(:deploy_to) {"#{app_path}#{application}"}

# Rails specific vars
set :normalize_asset_timestamps, false

# Rake variables
# set :rake, "#{rake} --trace"

namespace :rails_config do
  desc "Set RailsConfig servers"
  task :set_servers do
    server "#{app_settings[:servers].first}", :app, :web, :db, :primary => true
    app_settings[:servers].slice(1, app_settings[:servers].length-1).each do |host|
      server "#{host}", :app, :web
    end
  end

  namespace :newrelic do
    desc "Write New Relic file without ERB for processing by New Relic rpm recipe"
    task :set do
      run_locally "bundle exec rake nyu:newrelic:set RAILS_ENV=#{rails_env}"
    end

    desc "Reset the New Relic file"
    task :reset do
      run_locally "bundle exec rake nyu:newrelic:reset RAILS_ENV=#{rails_env}"
    end
  end

  desc "See RailsConfig settings"
  task :see do
    p "Settings: #{app_settings}"
    p "Servers: #{find_servers}"
    p "SCM Username: #{scm_username}"
    p "App Path: #{app_path}"
    p "User: #{user}"
    p "Deploy To: #{deploy_to}"
  end
end

namespace :deploy do
  desc "Start Application"
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
    run "cd #{current_path}"
  end
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
    run "cd #{current_path}"
  end
  task :stop, :roles => :app do
    run "cd #{current_path}"
  end
  task :passenger_symlink do
    run "rm -rf /apps/#{app_title} && ln -s #{current_path}/public /apps/#{app_title}"
  end
end

# Set the servers from rails config before we see
# what's in the rails config environment
before "rails_config:see", "rails_config:set_servers"
# After multistage is set, load up the rails config environment
after "multistage:ensure", "rails_config:see"
# After your bundle has installed, do any migrations
after "bundle:install", "deploy:migrate"
# Before newrelic runs, set up its yaml file
#before "newrelic:notice_deployment", "rails_config:newrelic:set"
# After newrelic runs, reset up its yaml file
#after "newrelic:notice_deployment", "rails_config:newrelic:reset"
#after "deploy:update", "newrelic:notice_deployment"
# Make sure correct ruby is installed
before "deploy", "rvm:install_ruby"
# Cleanup old deploys and set passenger symbolic link
after "deploy", "deploy:cleanup", "deploy:passenger_symlink"
