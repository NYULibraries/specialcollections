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
  Rake.application.delete_task("solr_ead:delete")
end
# Open up solr_ead rake task and load rails environment before calling recursive indexing task
namespace :solr_ead do

  desc "Index and ead into solr using FILE=<path/to/ead.xml>"
  task :index, [:simple] => :environment do |t, args|
    args.with_defaults(:simple => true)
    raise "Please specify your ead, ex. FILE=<path/to/ead.xml>" unless ENV['FILE']
    print "Indexing #{File.basename(file)}..."
    indexer = SolrEad::Indexer.new(:document=>CustomDocument, :simple => eval(args[:simple]))
    indexer.update_without_commit(ENV['FILE'])
    print "done.\n"
    indexer.solr.commit
  end

  desc "Delete and ead from your solr index using ID='<eadid>'"
  task :delete => :environment do
    raise "Please specify your ead id, ex. ID=<eadid>" unless ENV['ID']
    indexer = SolrEad::Indexer.new(:document=>CustomDocument)
    indexer.delete(ENV['ID'])
  end

  desc "Index a directory of ead files given by DIR=path/to/directory"
  task :index_dir, [:simple] => :environment do |t, args|
    args.with_defaults(:simple => true)
    raise "Please specify your direction, ex. DIR=path/to/directory" unless ENV['DIR']
    indexer = SolrEad::Indexer.new(:document=>CustomDocument, :simple => eval(args[:simple]))
    Dir.glob(File.join(ENV['DIR'],"*")).each do |file|
      print "Indexing #{File.basename(file)}..."
      indexer.update(file) if File.extname(file).match("xml$")
      print "done.\n"
    end
  end
  
  desc "Index a directory recursively of ead files given by DIR=path/to/directory"
  task :index_tree, [:bulk, :simple] => :environment do |t, args|
    args.with_defaults(:bulk => 1)
    args.with_defaults(:simple => true)
    raise "Please specify your direction, ex. DIR=path/to/directory" unless ENV['DIR']
    indexer = SolrEad::Indexer.new(:document=>CustomDocument, :simple => eval(args[:simple]))
    print "Indexing tree #{ENV['DIR']}...\n"
    i, tree = 0, ENV['DIR']
    Dir.glob(File.join(tree,"*","*")).each_with_index do |file, i|
      repo = file.split("\/")[-2]
      ENV['REPO'] = repo
      if File.extname(file).match("xml$")
        print "Indexing #{repo}/#{File.basename(file)}..."
        indexer.update_without_commit(file) 
      else
        print "Skipping #{repo}/#{File.basename(file)}..."
      end
      i += 1
      print "done.\n"
      if (i % args[:bulk].to_i == 0) or (i >= Dir.glob(File.join(tree,"*","*")).count)
        print "Committing to solr..."
        indexer.solr.commit 
        print "done.\n"
      end
    end
  end

end

