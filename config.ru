# This file is used by Rack-based servers to start the application.
require 'rack'
require_relative 'config/metrics'

require ::File.expand_path('../config/environment',  __FILE__)

use Rack::Deflater
# Run prometheus middleware to collect default metrics
use Prometheus::Middleware::CollectorWithExclusions
# Run prometheus exporter to have a /metrics endpoint that can be scraped
# The endpoint will only be available to prometheus
use Prometheus::Middleware::Exporter

if ENV['DOCKER']
  map(ENV['RAILS_RELATIVE_URL_ROOT'] || "/") { run Findingaids::Application }
else
  run Findingaids::Application
end
