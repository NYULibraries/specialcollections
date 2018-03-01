require 'formaggio/capistrano'

set :app_title, "findingaids"

set :rvm_ruby_string, "2.3.6"

namespace :deploy do
  # Remove EADs from server after deploying
  task :remove_eads do
    run "rm -rf #{current_path}/findingaids_eads"
  end
  # Remove EADs from local repos after deploying
  task :remove_local_eads do
    run_locally "rm -rf ./findingaids_eads"
  end
end
