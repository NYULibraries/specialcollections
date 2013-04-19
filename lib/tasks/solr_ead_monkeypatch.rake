require File.join(File.dirname(__FILE__), '..', '..', 'config', 'initializers', 'solr_ead_monkeypatch.rb')
require File.join(File.dirname(__FILE__), '..', 'findingaids', 'custom_document.rb')

# Delete rake tasks defined by solr_ead gem so we can redefine them
Rake::TaskManager.class_eval do
  def delete_task(task_name)
    @tasks.delete(task_name.to_s)
  end
  def show_tasks
    pp @tasks
  end
  Rake.application.delete_task("solr_ead:index_dir")
end

namespace :solr_ead do
  desc "Index a directory of ead files given by DIR=path/to/directory"
  task :index_dir do
    raise "Please specify your direction, ex. DIR=path/to/directory" unless ENV['DIR']
    indexer = SolrEad::Indexer.new(:document=>CustomDocument)
    Dir.glob(File.join(ENV['DIR'],"*")).each do |file|
      print "Indexing #{File.basename(file)}..."
      indexer.update(file) if File.extname(file).match("xml$")
      print "done.\n"
    end
  end
end
