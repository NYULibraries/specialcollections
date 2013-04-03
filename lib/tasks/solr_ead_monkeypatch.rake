# Open up solr_ead rake task and load rails environment before calling recursive indexing task
namespace :solr_ead do
  desc "Load environment and call index_dir"
  task :index_dir_patch => :environment do
    Rake::Task["solr_ead:index_dir"].invoke
  end
end