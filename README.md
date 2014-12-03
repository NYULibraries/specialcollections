# Finding Aids

[![Build Status](https://api.travis-ci.org/NYULibraries/findingaids.png)](https://travis-ci.org/NYULibraries/findingaids)
[![Dependency Status](https://gemnasium.com/NYULibraries/findingaids.png)](https://gemnasium.com/NYULibraries/findingaids)
[![Code Climate](https://codeclimate.com/github/NYULibraries/findingaids.png)](https://codeclimate.com/github/NYULibraries/findingaids)
[![Coverage Status](https://coveralls.io/repos/NYULibraries/findingaids/badge.png?branch=master)](https://coveralls.io/r/NYULibraries/findingaids)

A search interface powered by [Blacklight](http://projectblacklight.org/) for special collections finding aids imported in EAD format. Read [the wiki](/NYULibraries/findingaids/wiki) for more information.

## Overview

Finding Aids uses the [solr_ead](https://github.com/awead/solr_ead) gem to index EADs into Solr, specifically a cloud-hosted WebSolr index for this implementation. Then we have a [blacklight](https://github.com/projectblacklight/blacklight) instance sitting on top for a refined search.

## See it in action!

Visit https://webdev3.library.nyu.edu/findingaids

## Use with WebSolr

In WebSolr set up a new instance for EAD indexing with the Blacklight Demo schema.xml. See the `solr/schema.xml` in this repo for schema tweaks.

