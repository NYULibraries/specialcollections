# Getting Started

This application is an implementation of [Blacklight](http://projectblacklight.org/) but we're ingesting [EADs (Encoded Archival Description)](http://www.loc.gov/ead/tglib/element_index.html) instead of Marc. Please make sure to familiarize yourself with the [Blacklight Quickstart Guide](https://github.com/projectblacklight/blacklight/wiki/Quickstart) for dependencies and background before getting started with Finding Aids.

The description of EAD in Solr proves to require more configuration so we use [a more comprehensive Solr schema.xml](https://github.com/awead/solr_ead/blob/master/solr/schema.xml). To get your environment working you'll need to generate a jetty-solr instance and then copy our custom schema.xml. We've generated some tasks to help you get started. You can follow the steps below to get your development environment ready:

# Prerequisites

1. Java
  - We are using Java 1.7.  
  - If you need to run multiple versions of Java on your machine, you might want to look at [jEnv](http://www.jenv.be/)

# Setting Up Your Environment

1. Start by cloning this repository locally:

  ```
  ~$ git clone git@github.com:NYULibraries/findingaids.git
  ~$ cd findingaids; bundle install
  ```

2. Create your database and run your migrations:

  ```
  ~$ bundle exec rake db:create
  ~$ bundle exec rake db:migrate
  ~$ RAILS_ENV=test bundle exec rake db:migrate
  ```

3. Generate and start a local solr that is Finding Aids ready with the SolWrapper gem:

  ```
  ~$ RAILS_ENV=test bundle exec solr_wrapper
  ```

  You could run this in the background by appending `&` but it's also useful to know when you're running which version of solr.

4. Make sure all your tests are passing:

  ```
  ~$ bundle exec rake
  ```

5. Kill the test solr if you're not currently using it and start up a development one:

  ```
  ~$ bundle exec solr_wrapper
  ```

6. We're actively persisting the data in these test and development solr cores so if you need to purge the persisted data run the following:

  ```
  ~$ bundle exec solr_wrapper clean
  ```

7. Load some test data in there:

  ```
  ~$ bundle exec rake ead_indexer:index EAD=spec/fixtures/fales/bytsura.xml
  ~$ bundle exec rake ead_indexer:index EAD=spec/fixtures/tamwag/PHOTOS.107-ead.xml
  ```

8. And start up your local server:

  ```
  ~$ bundle exec rails server
  ```

9. Visiting `http://localhost:3000` should present you with the development application.


## Developer Notes:
1. Running the code in V1 (legacy) and V2 (FADESIGFINDINGAIDS_2022_MIGRATION) modes:
  You can use the `FINDINGAIDS_2022_MIGRATION` environment variable to control application behavior.  
  If `ENV['FINDINGAIDS_2022_MIGRATION']` is `nil`, then the application will operate in legacy mode.  
  If `ENV['FINDINGAIDS_2022_MIGRATION']` is not `nil`, then the application will operate in the `FINDINGAIDS_2022_MIGRATION` mode.   

2. Adding a new archival repository
  To add a new archival repository, e.g., `arabartarchive`, you need to update the following files:
  a.) the `config/repositories.yml` and `config/repositories-findingaids_2022_migration.yml` files
  b.) the `config/locales/en.yml` file
      * The only required key/value pair for the new repository is `url`

