require 'fileutils'
require 'findingaids'
if ENV['RAILS_ENV'] == 'test'
  require 'webmock'
  WebMock.allow_net_connect!
end

namespace :findingaids do

  namespace :solr do
    desc "Copies the default solr config to solr_wrapper generated config"
    task :config do
      FileList['solr/conf/*'].each do |f|
        destination_path = Rails.root.join('solr-test','server','solr','test-core','conf',"#{File.basename(f)}")
        if File.directory?(f)
          cp_r("#{f}", destination_path, verbose: true)
        else
          cp("#{f}", destination_path, verbose: true)
        end
      end
      # cp('solr/solr.xml', Rails.root.join('solr-test','server','solr','solr.xml'), verbose: true)
      cp_r(Rails.root.join('solr-test','server','solr','test-core','conf'), Rails.root.join('solr-test','server','solr','development-core'))
    end

  end

end
