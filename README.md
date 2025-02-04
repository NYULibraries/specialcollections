# Finding Aids

[![CircleCI](https://circleci.com/gh/NYULibraries/specialcollections.svg?style=svg)](https://circleci.com/gh/NYULibraries/specialcollections)
[![Maintainability](https://api.codeclimate.com/v1/badges/6ee3a05c26825862c264/maintainability)](https://codeclimate.com/github/NYULibraries/findingaids/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/NYULibraries/findingaids/badge.svg?branch=master)](https://coveralls.io/github/NYULibraries/findingaids?branch=master)

A search interface powered by [Blacklight](http://projectblacklight.org/) for special collections finding aids. Read [the wiki](https://github.com/NYULibraries/findingaids/wiki) for more information.

## Getting Started

Read the [GETTING STARTED guide](GETTING_STARTED.md) for a fuller walkthrough, or follow the steps below to get started quickly.

You could run the tests on your machine:

```
RAILS_ENV=test bundle exec solr_wrapper &
RAILS_ENV=test bundle exec rake
```

Or use docker:

```bash
# Build
docker compose build
# Run tests
docker compose run test
# Run the dev server
docker compose up dev
```

Then you should be able to go to `http://localhost:9292`.

### Developing with test user

Set `RAILS_ENV=development` in test.env to trigger `current_user_dev` method defined in `ApplicationController`. 

### Developing against live data

Set the following environment variables to their appropriate values: `SOLR_URL`, `FINDINGAIDS_DB_DATABASE`, `FINDINGAIDS_DB_HOST`, `FINDINGAIDS_DB_PASSWORD`, and `FINDINGAIDS_DB_USER`

Also ensure that `SOLR_URL` and `DEV_SOLR_URL` are unset or commented out (they are set in test.env).

### Loggings

Logging on Docker occurs to stdout for Kubernetes compatibility. Log level defaults to `:warn` but is configurable via `RAILS_LOG_LEVEL`.

## See it in action!

Development: https://specialcollections.library.nyu.edu/search

## Use with WebSolr

In WebSolr set up a new instance for EAD indexing with the Blacklight Demo schema.xml.

See the [`solr/conf/solrconfig.xml`](solr/conf/solrconfig.xml) for solr config tweaks.

See the [`solr/conf/schema.xml`](solr/conf/schema.xml) for schema tweaks.
