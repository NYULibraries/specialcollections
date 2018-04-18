ENV['RAILS_ENV'] = ENV['RACK_ENV']

require 'fileutils'
# set path to app that will be used to configure unicorn,
# note the trailing slash in this example
@dir = "#{File.expand_path(File.dirname(__FILE__))}/../../"

# Let X be your average memory usage, let B be your box's memory, and let C be your workers.
# C = (B/X).floor # e.g. (512MB/20MB).floor = 2 workers
worker_processes 2
working_directory @dir

timeout 30
preload_app false

# Dev port
listen (ENV['UNICORN_PORT'] || 9292)

# create tmp/pids in root
pids_dir = "#{@dir}tmp/pids/"
unless File.directory?(pids_dir)
  FileUtils.mkdir_p(pids_dir)
end

# Set process id path
@pid_file = "#{pids_dir}unicorn.pid"

pid @pid_file
