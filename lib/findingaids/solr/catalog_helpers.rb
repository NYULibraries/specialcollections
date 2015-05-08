module Findingaids
  module Solr
    module CatalogHelpers
      extend ActiveSupport::Concern

      # Adds the solr_name method, etc. to the catalog controller
      module ClassMethods
        # Convenience method for use in the Catalog config
        def solr_name(name, *opts)
          Solrizer.solr_name(name, *opts)
        end

        # Display fields
        def display_fields
          @display_fields ||= "*"
        end

        # Query fields
        def qf_fields
          @qf_fields ||= [
            "#{solr_name("unittitle", :searchable)}^145.0",
            "#{solr_name("parent_unittitles", :searchable)}",
            "#{solr_name("collection", :searchable)}",
            "#{solr_name("unitid", :searchable)}^60",
            "#{solr_name("collection_unitid", :searchable)}^40",
            "#{solr_name("language", :displayable)}",
            "#{solr_name("unitdate_start", :searchable)}",
            "#{solr_name("unitdate_end", :searchable)}",
            "#{solr_name("unitdate", :searchable)}",
            "#{solr_name("name", :searchable)}",
            "#{solr_name("subject", :searchable)}^60.0",
            "#{solr_name("abstract", :searchable)}^55.0" ,
            "#{solr_name("creator", :searchable)}^60.0",
            "#{solr_name("scopecontent", :searchable)}^60.0",
            "#{solr_name("bioghist", :searchable)}^55.0",
            "#{solr_name("title", :searchable)}",
            "#{solr_name("material_type", :searchable)}",
            "#{solr_name("place", :searchable)}",
            "#{solr_name("dao", :searchable)}",
            "#{solr_name("chronlist", :searchable)}",
            "#{solr_name("appraisal", :searchable)}",
            "#{solr_name("custodhist", :searchable)}^15",
            "#{solr_name("acqinfo", :searchable)}^20.0",
            "#{solr_name("address", :searchable)}",
            "#{solr_name("note", :searchable)}^30.0",
            "#{solr_name("author", :searchable)}^10.0"
          ].join(" ")
        end

        # Facet fields and their relevant configs
        def facet_fields
          @facet_fields ||= [
            { field: "repository", label: "Library", helper_method: :render_repository_facet_link },
            { field: "dao", label: "Digital Content" },
            { field: "creator", label: "Creator", limit: 20 },
            { field: "date_range", label: "Date Range", limit: 20 },
            { field: "subject", label: "Subject", limit: 20 },
            { field: "name", label: "Name", limit: 20 },
            { field: "place", label: "Place", limit: 20 },
            { field: "material_type", label: "Material Type", limit: 20 },
            { field: "language", label: "Language", limit: 20 },
            { field: "collection", label: "Collection", limit: 20 },
            { field: "format", label: "Level", limit: 20 }
          ]
        end

        # Advanced search facet fields and their relevant configs
        # NOTE: The order of this doesn't matter because it uses the order from the facets above
        def advanced_facet_fields
          @advanced_facet_fields ||= [
            { field: "format", label: "Level" },
            { field: "repository", label: "Library" },
            { field: "dao", label: "Digital Content" },
            { field: "date_range", label: "Date Range" }
          ]
        end

        # Fields that should only exist in the advanced search
        def advanced_search_fields
          @advanced_search_fields ||= [
            { field: "unittitle", label: "Title" },
            { field: "unitid", label: "Call No." },
            { field: "collection", label: "Collection" }
          ]
        end

        # Phrase fields
        def pf_fields
          @pf_fields ||= qf_fields
        end

        # Boost query fields will boost relevance in descending order of EAD level:
        # =>  Collection by 250
        # =>  Series by 150
        # =>  Subseries by 50
        # =>  File by 20
        # =>  Item not at all
        def bq_fields
          @bq_fields ||= [
            "#{solr_name("format", :facetable)}:\"Archival Collection\"^250",
            "#{solr_name("level", :facetable)}:series^150",
            "#{solr_name("level", :facetable)}:subseries^50",
            "#{solr_name("level", :facetable)}:file^20",
            "#{solr_name("level", :facetable)}:item"
          ]
        end
      end
    end
  end
end
