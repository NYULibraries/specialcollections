require 'solr_ead'
require 'fileutils'

class Findingaids::Ead::Indexer

  def self.delete_all
    Blacklight.solr.delete_by_query("*:*")
    Blacklight.solr.commit
  end

  attr_accessor :indexer

  def initialize
    @indexer = SolrEad::Indexer.new(document: Findingaids::Ead::Document, component: Findingaids::Ead::Component)
  end

  def index(file)
    unless File.directory?(file)
      update(file)
    else
      Dir.glob(File.join(file,"*")).each do |file|
        update(file)
      end
    end
  end

  def reindex_changed
    changed_files.each do |file|
      status, filename = file.split("\t")
      fullpath = File.join("data", filename)
      update_or_delete(fullpath)
    end
  end

private

  def last_commit
    @last_commit ||= `cd data && git log --pretty=format:'%h' -1 && cd ..`
  end

  def changed_files
    @changed_files ||= (`cd data && git diff-tree --no-commit-id --name-status -r #{last_commit} && cd ..`).split("\n")
  end

  def update_or_delete(file)
    if File.exists?(file)
      update(file)
    # Status == D means the file was deleted
    elsif status.eql? "D"
      delete(file)
    end
  end

  # Wrapper method for SolrEad::Indexer#update(file)
  # => @file      filename of EAD
  def update(file)
    if file.blank?
      raise ArgumentError.new("Expecting #{file} to be a file or directory")
    end
    begin
      indexer.update(file)
      log.info "Indexed #{File.basename(file)}."
    rescue
      log.info "Failed to index #{File.basename(file)}."
    end
  end

  # Wrapper method for SolrEad::Indexer#delete
  # => @id        EAD id
  def delete(file)
    if file.blank?
      raise ArgumentError.new("Expecting #{file} to be a file or directory")
    end
    id = File.basename(file).split("\.")[0]
    begin
      delete(id)
      log.info "Deleted #{File.basename(file)} with id #{id}."
    rescue
      log.info "Failed to delete #{File.basename(file)} with id #{id}."
    end
  end

  # Set FINDINGAIDS_LOGGER=STDOUT to view logs in standard out
  def log
    @log ||= (ENV['FINDINGAIDS_LOG']) ? Logger.new(ENV['FINDINGAIDS_LOG'].constantize) : Rails.logger
  end
end
