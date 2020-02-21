require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'

module Prometheus::Middleware
  class CollectorWithExclusions < Collector
    attr_reader :application_name
    def initialize(app, options = {})
      @exclude = EXCLUDE
      @application_name = "specialcollections"
      options[:metrics_prefix] = ENV['PROMETHEUS_METRICS_PREFIX']

      super(app, options)   
    end

    def call(env)
      if @exclude && @exclude.call(env)
        @app.call(env)
      else
        super(env)
      end
    end

    def init_request_metrics
      @requests = @registry.counter(
        :"#{@metrics_prefix}_requests_total",
        docstring:
          'The total number of HTTP requests handled by the Rack application.',
        labels: %i[code method path app]
      )
      @durations = @registry.histogram(
        :"#{@metrics_prefix}_request_duration_seconds",
        docstring: 'The HTTP response duration of the Rack application.',
        labels: %i[method path app]
      )
    end

    def record(env, code, duration)
      counter_labels = {
        code:   code,
        method: env['REQUEST_METHOD'].downcase,
        path:   strip_ids_from_path(env['PATH_INFO']),
        app:    application_name,
      }

      duration_labels = {
        method: env['REQUEST_METHOD'].downcase,
        path:   strip_ids_from_path(env['PATH_INFO']),
        app:    application_name,  
      }

      @requests.increment(labels: counter_labels)
      @durations.observe(duration, labels: duration_labels)
    rescue
      # TODO: log unexpected exception during request recording
      nil
    end

    # Strip out hashes in the form:
    #   /assets/icons-fe172n3-89uheh83hnuf9fh3fff.png, etc.
    # Strip out searches that are made from the bookmarks search
    # Strip out and merge paths with trailing slashes
    def strip_ids_from_path(path)
      super(path)
        .gsub(/(.*assets.*\/)(.+?)-(.+?)\.(.{2,4})/, '\1\2-:asset_hash.\4')
        .gsub(/(search\/bookmarks\/)(.+)/, '\1:bookmarks_search')
        # .gsub(/\/+$/,'')
    end

  protected

    EXCLUDE = proc do |env|
      !(env['PATH_INFO'].match(%r{^(/search)?/(metrics|healthcheck)})).nil?
    end

  end
end
