# Finding Aids

[![Build Status](https://api.travis-ci.org/NYULibraries/findingaids.png)](https://travis-ci.org/NYULibraries/findingaids)
[![Code Climate](https://codeclimate.com/github/NYULibraries/findingaids.png)](https://codeclimate.com/github/NYULibraries/findingaids)
[![Dependency Status](https://gemnasium.com/NYULibraries/findingaids.png)](https://gemnasium.com/NYULibraries/findingaids)
[![Coverage Status](https://coveralls.io/repos/NYULibraries/findingaids/badge.png?branch=master)](https://coveralls.io/r/NYULibraries/findingaids)

A refactoring of the dlib finding aids with Blacklight.

## Overview

Finding Aids uses the [solr_ead](https://github.com/awead/solr_ead) gem to index EADs into Solr, specifically a cloud-hosted WebSolr index for this implementation. Then we have a [blacklight](https://github.com/projectblacklight/blacklight) instance sitting on top for a refined search.

## Indexing EAD files

    $ rake solr_ead:index FILE=examples/pe_bakery.xml

To batch index directories:

    rake solr_ead:index_dir DIR=<DIR_NAME>
    
To delete all records from the index do the following in the console:

    indexer = SolrEad::Indexer.new
    indexer.solr.delete_by_query("*:*")
    
Or the following for a less all-encompassing delete:

    indexer.solr.delete_by_query("respository_s:fales")

### Custom document definition

SolrEad allows for the definition of a CustomDocument which overrides the default terminology when converting the EAD into a Solr document (the terminology is written in [om](https://github.com/projecthydra/om) format). This CustomDocument can be  found in `lib/findingaids/custom_document.rb` with further formatting done in `lib/findingaids/record.rb`. See the [solr_ead](https://github.com/awead/solr_ead) documentation for more information on custom documents.
    
### Component indexing and searching

EAD XML documents have separate components denoted by `<c>` elements, which SolrEad indexes separately with a reference back to its parent EAD. Similarly to the CustomDocument, a CustomComponent can be and is defined at `lib/findingaids/custom_component.rb`. 
  
In Finding Aids, we've indexed the components' relevant elements (i.e. odd and unittitle) as full-text in the main EAD document so we can quickly discover if the query exists anywhere in the EAD fields. Once the query is found in these fields, however, we have to retrieve the component documents from the index. A helper class exists in this application (`lib/findingaids/component_search.rb`) to search the components once a parent EAD is found. These acrobatics are done so we can link directly to the page in the Finding Aid where the query was found. 

Usage, where `field` is a Blacklight solr field (i.e. `<Hash {:document => SolrDocument, :field => FIELD_NAME}>`):

    solr_search = Findingaids::ComponentSearch.new(field)
    solr_search.solr_select
    
Optionally add solr parameters to default search:

    solr_search = Findingaids::ComponentSearch.new(field)
    solr_search.solr_params.merge!({ :fl => "*" })
    solr_search.solr_params[:fq] << "respository_s:fales"
    solr_search.solr_select

Returns an RSolr document with the solr response from the query. Use the accessor methods once the result is found:

    solr_search.has_results? # Did the search find anything?
    solr_search.docs # The documents found in the response
    solr_search.highlighting # The highlighted fields found

## Look at the sample records

Visit <http://webdev3.library.nyu.edu/findingaids>

## Use with WebSolr

In WebSolr set up a new instance for EAD indexing with the Blacklight Demo schema.xml. See the `solr/schema.xml` in this repo for schema tweaks.

## Notes

* Uses [Blacklight](https://github.com/projectblacklight/blacklight) 4.0 and [Solr](http://lucene.apache.org/solr/) 4.0.0
* Uses [solr_ead](https://github.com/awead/solr_ead) gem for indexing
* Uses [nyulibraries_assets](https://github.com/NYULibraries/nyulibraries_assets) gem for theming 
* Uses [RSolr](https://github.com/mwmitchell/rsolr) for component search in Solr
* Uses [WebSolr](http://www.websolr.com) for cloud-hosting Solr index solution
