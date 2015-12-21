require 'solr_ead'
require 'fileutils'
##
# Ead Indexer
#
# This class will index a file or directory into a Solr index configured via solr.yml
# It essentially wraps the functionality of SolrEad::Indexer with some customizations
# mainly the ability to index directories and reindex changed files from a Git diff.
#
# The #index function takes in a file or directory and calls update on all the valid .xml files it finds.
# The #reindex_changed_since_last_commit function finds all the files changed since the previous commit and updates, adds or deletes accordingly.
# The #reindex_changed_since_yesterday function finds all the files changed since yesterday and updates, adds or deletes accordingly.
# The #reindex_changed_since_last_week function finds all the files changed since last week and updates, adds or deletes accordingly.
# The .delete_all convenience method wraps Blacklight.solr to easily clear the index
class Findingaids::Ead::Indexer

  def self.delete_all
    Blacklight.solr.delete_by_query("*:*")
    Blacklight.solr.commit
  end

  attr_accessor :indexer, :data_path

  def initialize(data_path="findingaids_eads")
    @data_path = data_path
    @indexer = SolrEad::Indexer.new(document: Findingaids::Ead::Document, component: Findingaids::Ead::Component)
  end

  def index(file)
    if file.blank?
      raise ArgumentError.new("Expecting #{file} to be a file or directory")
    end
    unless File.directory?(file)
      update(file)
    else
      Dir.glob(File.join(file,"*")).each do |file|
        update(file)
      end
    end
  end

  # Reindex files changed only since the last commit
  def reindex_changed_since_last_commit
    reindex_changed(commits)
  end

  # Reindex all files changed in the last day
  def reindex_changed_since_yesterday
    reindex_changed(commits('--since=1.day'))
  end

  # Reindex all files changed in the last day
  def reindex_changed_since_last_week
    reindex_changed(commits('--since=1.week'))
  end

private

  # Reindex files changed in list of commit SHAs
  def reindex_changed(last_commits)
    changed_files(last_commits).each do |file|
      status, filename, message = file.split("\t")
      fullpath = File.join(data_path, filename)
      update_or_delete(status, fullpath, message)
    end
  end

  # TODO: Make time range configurable by instance variable
  #       and cascade through to rake jobs

  # Get the sha for the time range given
  #
  # time_range    git option to get set of results based on a date/time range;
  #               default is -1, just the last commit
  def commits(time_range = '-1')
    @commits ||= `cd #{data_path} && git log --pretty=format:'%h' #{time_range} && cd ..`.split("\n")
  end

  # Get list of files changed since last commit
  def changed_files(last_commits)
    changed_files = []
    last_commits.each do |commit|
      files_in_commit = (`cd #{data_path} && git diff-tree --no-commit-id --name-status -r #{commit} && cd ..`).split("\n")
      commit_message = (`cd #{data_path} && git log --pretty=format:'%s' -1 -c #{commit} && cd ..`).gsub(/(\n+)$/,'')
      files_in_commit.each do |changed_file|
        changed_files << [changed_file, commit_message].join("\t")
      end
    end
    changed_files.flatten
  end

  # Update or delete depending on git status
  def update_or_delete(status, file, message)
    eadid = get_eadid_from_message(file, message)
    if File.exists?(file)
      update(file)
    # Status == D means the file was deleted
    elsif status.eql? "D"
      delete(file, eadid)
    end
  end

  def get_eadid_from_message(file, message)
    # Strip out initial folder name to match filename in commit message
    file_without_data_path = file.gsub(/#{data_path}(\/)?/,'')
    eadid_matches = message.match(/#{file_without_data_path} EADID='(.+?)'/)
    eadid_matches.captures.first unless eadid_matches.nil?
  end

  # Wrapper method for SolrEad::Indexer#update(file)
  # => @file      filename of EAD
  def update(file)
    if file.blank?
      raise ArgumentError.new("Expecting #{file} to be a file or directory")
    end
    begin
      # The document is built around a repository that relies on the folder structure
      # since it does not exist consistently in the EAD, so we pass in the full path to extract the repos.
      ENV["EAD"] = file
      indexer.update(file)
      log.info "Indexed #{file}."
    rescue Exception => e
      log.info "Failed to index #{file}: #{e}."
      false
    end
  end

  # Wrapper method for SolrEad::Indexer#delete
  # => @id        EAD id
  def delete(file, eadid)
    if file.blank?
      raise ArgumentError.new("Expecting #{file} to be a file or directory")
    end
    # If eadid was passed in, use it to delete
    # it not, make a guess based on filename
    id = (eadid || File.basename(file).split("\.")[0])
    begin
      indexer.delete(id)
      log.info "Deleted #{file} with id #{id}."
    rescue Exception => e
      log.info "Failed to delete #{file} with id #{id}: #{e}"
      false
    end
  end

  # Set FINDINGAIDS_LOG=STDOUT to view logs in standard out
  def log
    @log ||= (ENV['FINDINGAIDS_LOG']) ? Logger.new(ENV['FINDINGAIDS_LOG'].constantize) : Rails.logger
  end
end
