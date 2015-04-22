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
        cp("#{f}", Rails.root.join('jetty','solr','blacklight-core','conf',"#{File.basename(f)}"), verbose: true)
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

  namespace :ead do

    desc "Index ead into solr using EAD=<FILE|DIR>"
    task :index => :environment do
      ENV['EAD'] = "spec/fixtures/ead" unless ENV['EAD']
      indexer = Findingaids::Ead::Indexer.new
      indexer.index(ENV['EAD'])
    end

    desc "Reindex only the files in the data repository that have changed since the last commit"
    task :reindex_changed => :environment do
      indexer = Findingaids::Ead::Indexer.new
      indexer.reindex_changed_since_last_commit
    end

    desc "Reindex only the files in the data repository that have changed since the last commit"
    task :reindex_changed_since_yesterday => :environment do
      indexer = Findingaids::Ead::Indexer.new
      indexer.reindex_changed_since_yesterday
    end

    desc "Deletes everything from the solr index"
    task :clean => :environment do
      Findingaids::Ead::Indexer.delete_all
    end

  end

end
