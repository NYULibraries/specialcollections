require "fileutils"
require "solr_ead"
require "findingaids"

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

    desc "Index ead into solr and create both html and json"
    task :index => :environment do
      ENV['EAD'] = "spec/fixtures/ead" unless ENV['EAD']
      indexer = SolrEad::Indexer.new(:document=>Findingaids::Ead::Document, :component=>Findingaids::Ead::Component)
      if File.directory?(ENV['EAD'])
        Dir.glob(File.join(ENV['EAD'],"*")).each do |file|
          print "Indexing #{File.basename(file)}: "
          begin
            indexer.update(file)
            #Findingaids::Ead::Indexing.ead_to_html(file)
            #Findingaids::Ead::Indexing.toc_to_json(File.new(file))
            #FileUtils.cp(file, Rails.configuration.findingaids_config[:ead_path])
            print "done.\n"
          rescue
            print "failed!\n"
          end
        end
      else
        indexer.update(ENV['EAD'])
        #Findingaids::Ead::Indexing.ead_to_html(ENV['EAD'])
        #Findingaids::Ead::Indexing.toc_to_json(File.new(ENV['EAD']))
        #FileUtils.cp(ENV['EAD'], Rails.configuration.findingaids_config[:ead_path])
      end
    end

    desc "Convert ead to html only"
    task :to_html => :environment do
      raise "Please specify a path to your ead, ex. EAD=<path/to/ead.xml" unless ENV['EAD']
      if File.directory?(ENV['EAD'])
        Dir.glob(File.join(ENV['EAD'],"*")).each do |file|
          puts "Converting #{File.basename(file)} to html"
          Findingaids::Ead::Indexing.ead_to_html(file) if File.extname(file).match("xml$")
        end
      else
        Findingaids::Ead::Indexing.ead_to_html(ENV['EAD'])
      end
    end

    desc "Convert ead to json only"
    task :to_json => :environment do
      raise "Please specify your ead, ex. EAD=<path/to/ead.xml" unless ENV['EAD']
      if File.directory?(ENV['EAD'])
        Dir.glob(File.join(ENV['EAD'],"*")).each do |file|
          puts "Converting #{File.basename(file)} to json"
          Findingaids::Ead::Indexing.toc_to_json(File.new(file))
        end
      else
        Findingaids::Ead::Indexing.toc_to_json(File.new(ENV['EAD']))
      end
    end

    desc "Reindex only the files in the data repository that have changed since the last commit"
    task :index_changed => :environment do
      indexer = SolrEad::Indexer.new(:document=>Findingaids::Ead::Document, :component=>Findingaids::Ead::Component)
      # Get sha from last commit
      sha = `cd data && git log --pretty=format:'%h' -1 && cd ..`
      # Get list of committed files on last commit as array, with status so we know when to delete
      committed_files = (`cd data && git diff-tree --no-commit-id --name-status -r #{sha} && cd ..`).split("\n")
      # Loop through array of committed files
      committed_files.each do |committed_file|
        # Separate into status and filename
        status, file = committed_file.split("\t")
        # Get full file path from app root
        file = File.join("data", file)
        # Repository is set from EAD env, assuming creating from the command line
        # with a passed in param EAD=(filename)
        ENV['EAD'] = file
        # If file exists...
        if File.exists?(file)
          print "Indexing #{File.basename(file)}: "
          begin
            #...reindex it!
            indexer.update(file)
            print "done.\n"
          rescue
            print "failed!\n"
          end
        elsif status.eql? "D"
          eadid = File.basename(file).split("\.")[0]
          print "Deleting #{File.basename(file)} with id #{eadid}: "
          begin
            Blacklight.solr.delete_by_query("ead_ssi:#{eadid}")
            Blacklight.solr.commit
            print "done.\n"
          rescue
            print "failed!\n"
          end
        end
      end
    end

  end

  namespace :solr do

    desc "Deletes everytyhing from the solr index"
    task :clean => :environment do
      Blacklight.solr.delete_by_query("*:*")
      Blacklight.solr.commit
    end

  end

end
