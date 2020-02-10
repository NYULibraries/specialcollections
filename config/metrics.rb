require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'

module Prometheus::Middleware
  class CollectorWithExclusions < Collector
    def initialize(app, options = {})
      @exclude = EXCLUDE
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

    # Strip out hashes in the form:
    #   /assets/icons-fe172n3-89uheh83hnuf9fh3fff.png, etc.
    # Strip out searches that are made from the bookmarks search
    # Strip out and merge paths with trailing slashes
    def strip_ids_from_path(path)
      super(path)
        .gsub(/(.*assets.*\/)(.+?)-(.+?)\.(.{2,4})/, '\1\2-:asset_hash.\4')
        .gsub(/(search\/bookmarks\/)(.+)/, '\1:bookmarks_search')
        .gsub(/\/+$/,'')
    end

  protected

    EXCLUDE = proc do |env|
      !(env['PATH_INFO'].match(%r{^(/search)?/(metrics|healthcheck)})).nil?
    end

  end
end
