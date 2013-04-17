# Delete rake tasks defined by solr_ead gem so we can redefine them
Rake::TaskManager.class_eval do
  def delete_task(task_name)
    @tasks.delete(task_name.to_s)
  end
  def show_tasks
    pp @tasks
  end
  Rake.application.delete_task("solr_ead:index")
  Rake.application.delete_task("solr_ead:index_dir")
end
# Open up solr_ead rake task and load rails environment before calling recursive indexing task
namespace :solr_ead do

  desc "Index and ead into solr using FILE=<path/to/ead.xml>"
  task :index, [:simple] => :environment do |t, args|
    args.with_defaults(:simple => true)
    raise "Please specify your ead, ex. FILE=<path/to/ead.xml>" unless ENV['FILE']
    print "Indexing #{File.basename(ENV['FILE'])}..."
    indexer = SolrEad::Indexer.new(:document=>CustomDocument, :simple => eval(args[:simple].to_s))
    indexer.batch_update(ENV['FILE'])
    print "done.\n"
    indexer.batch_commit
  end

  desc "Index a directory recursively of ead files given by DIR=path/to/directory"
  task :index_dir, [:batch, :simple] => :environment do |t, args|
    args.with_defaults(:simple => true, :batch => 500)
    raise "Please specify your directory, ex. DIR=path/to/directory" unless ENV['DIR']
    indexer = SolrEad::Indexer.new(:document=>CustomDocument, :simple => eval(args[:simple].to_s))
    print "Indexing tree #{ENV['DIR']}...\n"
    tree = ENV['DIR']
    Dir.glob(File.join(Rails.root,ENV['DIR'],"**","*.xml")).each do |file|
      repo = file.split("\/")[-2]
      ENV['REPO'] = repo
      if File.extname(file).match("xml$")
        print "Indexing #{repo}/#{File.basename(file)}..."
        indexer.batch_update(file) 
      else
        print "Skipping #{repo}/#{File.basename(file)}..."
      end
      print "done.\n"
    end
    print "Committing to solr..."
    #indexer.batch_commit(args[:batch])
    print "done.\n"
  end

end

