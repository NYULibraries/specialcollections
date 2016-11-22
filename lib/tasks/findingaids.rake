require 'fileutils'
require 'findingaids'
if ENV['RAILS_ENV'] == 'test'
  require 'webmock'
  WebMock.allow_net_connect!
end

namespace :findingaids do

  namespace :jetty do
    desc "Copies the default SOLR config for the bundled jetty"
    task :config_solr do
      FileList['solr/conf/*'].each do |f|
        destination_path = Rails.root.join('jetty','solr','blacklight-core','conf',"#{File.basename(f)}")
        if File.directory?(f)
          cp_r("#{f}", destination_path, verbose: true)
        else
          cp("#{f}", destination_path, verbose: true)
        end
      end
      cp('solr/solr.xml', Rails.root.join('jetty','solr','solr.xml'), verbose: true)
      mv(Rails.root.join('jetty','solr','blacklight-core'), Rails.root.join('jetty','solr','development-core'))
      cp_r(Rails.root.join('jetty','solr','development-core'), Rails.root.join('jetty','solr','test-core'))
    end

    desc 'Download a clean jetty for development and copy the customized schema.xml into it'
    task :install do
      Rake::Task["jetty:clean"].execute
      # Copying custom conf to generated jetty solr
      Rake::Task["findingaids:jetty:config_solr"].execute
    end
  end

end
