#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Findingaids::Application.load_tasks

if Rails.env.development? || Rails.env.test?
  ZIP_URL = "https://github.com/projectblacklight/blacklight-jetty/archive/v4.9.0.zip"
  require 'jettywrapper'
  require 'solr_wrapper/rake_task'
end

if Rails.env.test?
  require 'coveralls/rake/task'
  Coveralls::RakeTask.new
  task :default => [:spec, :cucumber, 'coveralls:push']
end
