# Finding Aids

[![Build Status](https://api.travis-ci.org/NYULibraries/findingaids.png)](https://travis-ci.org/NYULibraries/findingaids)
[![Code Climate](https://codeclimate.com/github/NYULibraries/findingaids.png)](https://codeclimate.com/github/NYULibraries/findingaids)
[![Dependency Status](https://gemnasium.com/NYULibraries/findingaids.png)](https://gemnasium.com/NYULibraries/findingaids)
[![Coverage Status](https://coveralls.io/repos/NYULibraries/findingaids/badge.png?branch=master)](https://coveralls.io/r/NYULibraries/findingaids)

A refactoring of the dlib finding aids into Blacklight.

## Getting started

After cloning the repository:

```bash
$ bundle install
```

Start Solr:

```bash
$ cd solr-dist
$ java -jar start.jar
```

In another terminal:

```bash
$ rake db:migrate
$ rails server
```
## Indexing EAD files

```bash
$ rake solr_ead:index FILE=examples/pe_bakery.xml
```

## Look at the sample records

Visit <http://webdev3.library.nyu.edu/findingaids>

## Use with WebSolr

In WebSolr set up a new instance for EAD indexing with the Blacklight Demo schema.xml.

To batch index directories:

    rake solr_ead:index_dir DIR=<DIR_NAME>

To delete all records from the index do the following in the console:

    indexer = SolrEad::Indexer.new
    indexer.solr.delete_by_query("*:*")

## Notes

* Uses Blacklight 4.1.0 and Solr 4.0.0
* Uses [solr_ead](https://github.com/awead/solr_ead) gem for indexing

## Screenshot

[![Screenshot](http://i.imgur.com/s2j3Q.png)](http://imgur.com/s2j3Q)
