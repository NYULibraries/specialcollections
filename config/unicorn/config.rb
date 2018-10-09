require 'fileutils'
# set path to app that will be used to configure unicorn,
# note the trailing slash in this example
@dir = "#{File.expand_path(File.dirname(__FILE__))}/../../"

# Let X be your average memory usage, let B be your box's memory, and let C be your workers.
# C = (B/X).floor # e.g. (512MB/20MB).floor = 2 workers
worker_processes Integer(ENV["UNICORN_WEB_CONCURRENCY"] || 2)
working_directory @dir

timeout 120
preload_app true

listen Integer(ENV['UNICORN_PORT'] || 9292)

# create tmp/pids and logs/ in root
pids_dir = "#{@dir}tmp/pids/"
logs_dir = "#{@dir}log/"
[pids_dir, logs_dir].each do |dirname|
  unless File.directory?(dirname)
    FileUtils.mkdir_p(dirname)
  end
end

# Set process id path
@pid_file = "#{pids_dir}unicorn.pid"

pid @pid_file

# Set log file paths
stderr_path "/dev/stderr"
stdout_path "/dev/stdout"
