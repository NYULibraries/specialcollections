class Findingaids::Ead::Component < SolrEad::Component

  include Findingaids::Ead::Behaviors

  use_terminology SolrEad::Component

  extend_terminology do |t|

    # <odd> nodes
    # These guys depend on what's in <head> so we do some xpathy stuff...
    t.odd(:path=>"odd", :index_as=>[:displayable,:searchable])
    t.date_filing(:path=>"unitdate/@normal", :index_as=>[:sortable])
    t.box_filing(:path=>"container[@type='Box']", :index_as=>[:sortable])
    t.folder_filing(:path=>"container[@type='Folder']", :index_as=>[:sortable])
    t.title_filing(:path=>"unittitle", :index_as=>[:sortable])

  end

  def to_solr(solr_doc = Hash.new)
    solr_doc = super(solr_doc)
    solr_doc.merge!(Solrizer.solr_name("repository", :stored_sortable) => format_repository)
    solr_doc.merge!(Solrizer.solr_name("repository", :facetable) => format_repository)

    Solrizer.insert_field(solr_doc, "format",     format_filing(solr_doc),                      :sortable)
    Solrizer.insert_field(solr_doc, "format",     format_display,                               :facetable)
    Solrizer.insert_field(solr_doc, "format",     format_display,                               :displayable)
    Solrizer.insert_field(solr_doc, "heading",    heading_display(solr_doc),                    :displayable)
    Solrizer.insert_field(solr_doc, "location",   location_display,                             :displayable)
    Solrizer.insert_field(solr_doc, "location",   location_display,                             :sortable)
    Solrizer.insert_field(solr_doc, "title",      self.title,                                   :searchable)

    # Collection field
    Solrizer.set_field(solr_doc, "collection",        collection_name(solr_doc),          :searchable)
    Solrizer.set_field(solr_doc, "collection",        collection_name(solr_doc),          :displayable)
    Solrizer.set_field(solr_doc, "collection",        collection_name(solr_doc),          :facetable)
    Solrizer.set_field(solr_doc, "series",            series_facets(solr_doc),            :facetable)
    Solrizer.set_field(solr_doc, "series",            series_sortable(solr_doc),          :sortable)

    # Replace certain fields with their html-formatted equivalents
    Solrizer.set_field(solr_doc, "title", self.term_to_html("title"), :displayable)

    # Set lanuage codes
    solr_doc.merge!(ead_language_fields)
    solr_doc
  end

protected

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

  def heading_display solr_doc
    if self.title.first.blank?
      self.term_to_html("unitdate") unless self.unitdate.empty?
    else
      title_for_heading(([collection_name(solr_doc)]<< solr_doc[Solrizer.solr_name("parent_unittitles", :displayable)]).flatten) unless solr_doc[Solrizer.solr_name("parent_unittitles", :displayable)].nil?
    end
  end

  def title_for_heading parent_titles = Array.new
    if parent_titles.length > 0
      [parent_titles, self.term_to_html("title")].join(" >> ")
    else
      self.term_to_html("title")
    end
  end

  def collection_name solr_doc
    solr_doc[Solrizer.solr_name("collection", :facetable)].strip
  end

  def format_display
    (self.title.first =~ /\ASeries|Subseries/) ? "Archival Series" : "Archival Item"
  end

  def format_filing solr_doc
    (([collection_name(solr_doc)]<< solr_doc[Solrizer.solr_name("parent_unittitles", :displayable)]).flatten).length
  end

  def series_facets solr_doc
    solr_doc[Solrizer.solr_name("parent_unittitles", :displayable)] unless solr_doc[Solrizer.solr_name("parent_unittitles", :displayable)].nil?
  end

  def series_sortable solr_doc
    title_for_heading(solr_doc[Solrizer.solr_name("parent_unittitles", :displayable)]) unless solr_doc[Solrizer.solr_name("parent_unittitles", :displayable)].nil?
  end

private

  def search(path)
    self.find_by_xpath(path)
  end

  def value(path)
    search(path).text
  end

end
