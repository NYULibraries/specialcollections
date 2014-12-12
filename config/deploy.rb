require 'formaggio/capistrano'

set :app_title, "findingaids"

set :rvm_ruby_string, "2.1.5"

namespace :deploy do
  task :remove_eads do
    run "rm -rf #{current_path}/data"
  end
end

after "deploy", "deploy:remove_eads"
