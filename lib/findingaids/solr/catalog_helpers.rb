module Findingaids
  module Solr
    module CatalogHelpers
      extend ActiveSupport::Concern

      # Adds the solr_name method, etc. to the catalog controller
      module ClassMethods
        def solr_name(name, *opts)
          Solrizer.solr_name(name, *opts)
        end

        def display_fields
          @display_fields ||= "*"
        end

        def qf_fields
          @qf_fields ||= ["#{solr_name("title", :displayable)}^2000.0",
                          "#{solr_name("parent_unittitles", :displayable)}^500.0",
                          "#{solr_name("collection", :searchable)}^1000.0",
                          "#{solr_name("title", :stored_searchable)}^1000.0",
                          "#{solr_name("title", :searchable)}^1000.0",
                          "#{solr_name("subject", :searchable)}^250.0",
                          "#{solr_name("abstract", :searchable)}^250.0" ,
                          "#{solr_name("controlaccess", :searchable)}^100.0",
                          "#{solr_name("scopecontent", :searchable)}^90.0",
                          "#{solr_name("bioghist", :searchable)}^80.0",
                          "#{solr_name("unittitle", :searchable)}^70.0",
                          "#{solr_name("odd", :searchable)}^60.0",
                          "#{solr_name("index", :searchable)}^50.0",
                          "#{solr_name("phystech", :searchable)}^40.0",
                          "#{solr_name("acqinfo", :searchable)}^30.0",
                          "#{solr_name("sponsor", :searchable)}^20.0",
                          "#{solr_name("custodhist", :searchable)}^10.0"].join(" ")
        end

        def pf_fields
          @pf_fields ||= qf_fields
        end

        def hl_fields
          @hl_fields ||= ["title","author","publisher","collection","parent_unittitles","location"].map { |field| solr_name(field, :displayable) }
        end
      end
    end
  end
end
