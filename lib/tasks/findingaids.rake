require "fileutils"
require "solr_ead"
require "findingaids"

namespace :findingaids do
  
  namespace :ead do

    desc "Index ead into solr and create both html and json"
    task :index => :environment do
      ENV['EAD'] = "spec/fixtures/ead" unless ENV['EAD']
      indexer = SolrEad::Indexer.new(:document=>Findingaids::Ead::Document, :component=>Findingaids::Ead::Component)
      if File.directory?(ENV['EAD'])
        Dir.glob(File.join(ENV['EAD'],"*")).each do |file|
          debugger
          print "Indexing #{File.basename(file)}: "
          begin
            indexer.update(file)
            Findingaids::Ead::Indexing.ead_to_html(file)
            Findingaids::Ead::Indexing.toc_to_json(File.new(file))
            FileUtils.cp(file, Rails.configuration.findingaids_config[:ead_path])
            print "done.\n"
          rescue
            print "failed!\n"
          end
        end
      else
        indexer.update(ENV['EAD'])
        Findingaids::Ead::Indexing.ead_to_html(ENV['EAD'])
        Findingaids::Ead::Indexing.toc_to_json(File.new(ENV['EAD']))
        FileUtils.cp(ENV['EAD'], Rails.configuration.findingaids_config[:ead_path])
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

  end

  namespace :solr do

    desc "Deletes everytyhing from the solr index"
    task :clean => :environment do
      Blacklight.solr.delete_by_query("*:*")
      Blacklight.solr.commit
    end

  end

end