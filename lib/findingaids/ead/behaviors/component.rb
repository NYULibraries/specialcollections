# Behaviors specific to components
module Findingaids::Ead::Behaviors
  module Component

    # Take the containers and formats them to look like:
    # => ["Box: 1, Folder: 2, Item: 3"]
    def location_display(locations = Array.new)
      self.container_id.each do |id|
        line = String.new
        line << "#{value("//container[@id = '#{id}']/@type")}: #{value("//container[@id = '#{id}']")}"
        sub_containers = Array.new
        search("//container[@parent = '#{id}']").each do |sub|
          sub_containers << "#{sub.attribute("type").text}: #{sub.text}"
        end
        line << ", #{sub_containers.join(", ")}" unless sub_containers.empty?
        locations << line
      end
      return locations
    end

    # Takes the combined headers of all parent titles to create the heading
    # unless there are no parent titles.
    #
    # E.g. ["Collection Name","Series I", "Sub-series III"] => "Collection Name >> Series I >> Sub-series III >> Unit Title"
    def title_for_heading(parent_titles = Array.new)
      if parent_titles.length > 0
        [parent_titles, self.term_to_html("unittitle")].join(" >> ")
      else
        self.term_to_html("unittitle")
      end
    end

    # Extract collection name from solr_doc
    # it was passed in via additional information from the collection level indexer
    def collection_name(solr_doc)
      solr_doc[Solrizer.solr_name("collection", :facetable)]
    end

    # Extract collection unit id from solr_doc
    # it was passed in via additional information from the collection level indexer
    def collection_unitid(solr_doc, unitids = Array.new)
      solr_doc[Solrizer.solr_name("collection_unitid", :displayable)]
    end

    # Extract collection name from solr_doc
    # it was passed in via additional information from the collection level indexer
    def author(solr_doc)
      solr_doc[Solrizer.solr_name("author", :searchable)]
    end

    # Hardcode the format name based on the @level attribute
    def format_display
      (self.level.first =~ /\Aseries|subseries/) ? "Archival Series" : "Archival Object"
    end

    # Make this components parents (i.e. the series it belongs to) FACETABLE
    # so that we can create faceted links to them
    def series_facets(solr_doc)
      solr_doc[Solrizer.solr_name("parent_unittitles", :displayable)] unless solr_doc[Solrizer.solr_name("parent_unittitles", :displayable)].nil?
    end

    # Make this components parents (i.e. the series it belongs to) SORTABLE
    # so that we can order series together
    def series_sortable(solr_doc)
      title_for_heading(solr_doc[Solrizer.solr_name("parent_unittitles", :displayable)]) unless solr_doc[Solrizer.solr_name("parent_unittitles", :displayable)].nil?
    end
  end
end
