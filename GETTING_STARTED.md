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
3. Generate a local jetty-solr that is Finding Aids ready:
```
~$ bundle exec rake findingaids:jetty:install
```
4. And start it up:
```
~$ bundle exec rake jetty:start
```
5. Load some test data in there:
```
~$ bundle exec rake findingaids:ead:index EAD=spec/fixtures/fales
~$ bundle exec rake findingaids:ead:index EAD=spec/fixtures/tamwag
```
6. Make sure all your tests are passing:
```
~$ bundle exec rake
```
7. And start up your local server:
```
~$ bundle exec rails s
```
8. Visiting `http://localhost:3000` should present you with the development application.
