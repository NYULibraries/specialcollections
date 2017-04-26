# Finding Aids

[![CircleCI](https://circleci.com/gh/NYULibraries/findingaids.svg?style=svg)](https://circleci.com/gh/NYULibraries/findingaids)
[![Dependency Status](https://gemnasium.com/NYULibraries/findingaids.png)](https://gemnasium.com/NYULibraries/findingaids)
[![Code Climate](https://codeclimate.com/github/NYULibraries/findingaids.png)](https://codeclimate.com/github/NYULibraries/findingaids)
[![Coverage Status](https://coveralls.io/repos/NYULibraries/findingaids/badge.png?branch=master)](https://coveralls.io/r/NYULibraries/findingaids)

A search interface powered by [Blacklight](http://projectblacklight.org/) for special collections finding aids. Read [the wiki](https://github.com/NYULibraries/findingaids/wiki) for more information.

## Getting Started

Read the [GETTING STARTED guide](GETTING_STARTED.md) for a fuller walkthrough, or follow the steps below to get started quickly.

You could run the tests on your machine:

```
RAILS_ENV=test bundle exec solr_wrapper &
RAILS_ENV=test bundle exec rake
```

Or use docker...

The following assumes you've set up docker/docker-compose/docker-machine running on your station:

```bash
docker-compose up -d
docker-compose run web rake db:create
docker-compose run -e RAILS_ENV=test web rake db:schema:load
# Run tests
docker-compose run web rake
```

### Developing in Docker

```bash
# Load schema in the dev database
~$ docker-compose run web bundle exec rake db:create
# Run the server
~$ docker-compose run --service-ports web rails s -b 0.0.0.0
```

Then you should be able to go to `http://{docker-machine ip}:3000` or if you've set it up in your `/etc/hosts`.

## See it in action!

Development: https://specialcollections.library.nyu.edu/search

## Use with WebSolr

In WebSolr set up a new instance for EAD indexing with the Blacklight Demo schema.xml.

See the [`solr/conf/solrconfig.xml`](solr/conf/solrconfig.xml) for solr config tweaks.

See the [`solr/conf/schema.xml`](solr/conf/schema.xml) for schema tweaks.
