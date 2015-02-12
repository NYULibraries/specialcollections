class Findingaids::Ead::Document < SolrEad::Document

  include Findingaids::Ead::Behaviors

  # Define each term in your ead that you want put into the solr document
  set_terminology do |t|
    t.root(path:"ead")
    t.eadid
    t.unittitle(path:"archdesc[@level='collection']/did/unittitle",index_as:[:searchable,:displayable])
    t.unitid(path:"archdesc[@level='collection']/did/unitid",index_as:[:searchable,:displayable])
    t.langcode(path:"archdesc[@level='collection']/did/langmaterial/language/@langcode")
    t.unitdate(path:"archdesc[@level='collection']/did/unitdate/@normal",index_as:[:displayable,:searchable,:facetable])
    t.abstract(path:"archdesc[@level='collection']/did/abstract",index_as:[:searchable,:displayable])
    t.creator(path:"archdesc[@level='collection']/did/origination[@label='creator']",index_as:[:searchable,:displayable])
    t.scopecontent(path:"archdesc[@level='collection']/scopecontent/p",index_as:[:searchable])
    t.bioghist(path:"archdesc[@level='collection']/bioghist/p",index_as:[:searchable])
    t.acqinfo(path:"archdesc[@level='collection']/acqinfo/p",index_as:[:searchable])
    t.custodhist(path:"archdesc[@level='collection']/custodhist/p",index_as:[:searchable])
    t.appraisal(path:"archdesc[@level='collection']/appraisal/p",index_as:[:searchable])
    t.chronlist(path:"archdesc[@level='collection']/bioghist/chronlist/chronitem/event",index_as:[:searchable])
    t.corpname(path:"archdesc[@level='collection']/corpname",index_as:[:searchable,:displayable])
    t.famname(path:"archdesc[@level='collection']/famname",index_as:[:searchable,:displayable])
    t.function(path:"archdesc[@level='collection']/function",index_as:[:searchable,:displayable])
    t.genreform(path:"archdesc[@level='collection']/genreform",index_as:[:searchable,:displayable])
    t.geogname(path:"archdesc[@level='collection']/geogname",index_as:[:searchable,:displayable])
    t.name(path:"archdesc[@level='collection']/name",index_as:[:searchable,:displayable])
    t.occupation(path:"archdesc[@level='collection']/occupation",index_as:[:searchable,:displayable])
    t.persname(path:"archdesc[@level='collection']/persname",index_as:[:searchable,:displayable])
    t.subject(path:"archdesc[@level='collection']/subject",index_as:[:searchable,:displayable])
    t.title(path:"archdesc[@level='collection']/title",index_as:[:searchable,:displayable])
    t.note(path:"archdesc[@level='collection']/note",index_as:[:searchable,:displayable])

    #Facets
    t.collection(proxy:[:unittitle],index_as:[:facetable,:displayable])
    t.material_type(proxy:[:genreform],index_as:[:facetable,:displayable])
  end

  def to_solr(solr_doc = Hash.new)
    solr_doc = super(solr_doc)

    # Populate repository code from indexing folder structure
    Solrizer.insert_field(solr_doc, "repository",   format_repository,      :stored_sortable, :facetable)
    # Create a formatted heading based on the title and unit id
    Solrizer.insert_field(solr_doc, "heading",      heading_display,        :displayable) unless self.unitid.empty?
    # Set the format to Archival Collection
    Solrizer.insert_field(solr_doc, "format",       "Archival Collection",  :facetable, :displayable)
    # Sortable element based on the type of thing this is, will help us sort by Collection, Series, etc.
    Solrizer.insert_field(solr_doc, "format",       0,                      :sortable)
    # Special formatting for some fields and facets
    Solrizer.insert_field(solr_doc, "creator",      get_ead_creators,       :displayable, :facetable)
    Solrizer.insert_field(solr_doc, "name",         get_ead_names,          :facetable)
    Solrizer.insert_field(solr_doc, "subject",      get_ead_subject_facets, :facetable)
    Solrizer.insert_field(solr_doc, "dao",          get_ead_dao_facet,      :facetable)

    # Replace certain fields with their html-formatted equivlents
    Solrizer.set_field(solr_doc, "unittitle", self.term_to_html("unittitle"), :displayable)

    # Set lanuage codes
    solr_doc.merge!(ead_language_fields)

    return solr_doc
  end

  protected
  ##
  # Create a heading display for archival collections
  #
  # self(title: "Interesting Items", title_num: "ABC.123") => "Guide to the Interesting Items (ABC.123)"
  def heading_display
    "Guide to the " + self.term_to_html("unittitle") + " (" + self.unitid.first + ")"
  end

end
