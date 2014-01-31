require 'nyulibraries/deploy/capistrano'
set :app_title, "findingaids"

namespace :deploy do
  task :remove_eads do
    run "rm -rf #{current_path}/data"
  end
end

after "deploy", "deploy:remove_eads"