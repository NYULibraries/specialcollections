class Findingaids::Ead::Component < SolrEad::Component

  include Findingaids::Ead::Behaviors
  include Findingaids::Ead::Behaviors::Component

  set_terminology do |t|
    t.root(path:"c")
    t.ref_(path:"/c/@id")
    t.level(path:"/c/@level", index_as:[:facetable])

    # Item
    t.container {
      t.label(path:{:attribute=>"label"})
      t.type(path:{:attribute=>"type"})
      t.id(path:{:attribute=>"id"})
    }
    t.container_label(:proxy=>[:container, :label])
    t.container_type(:proxy=>[:container, :type])
    t.container_id(:proxy=>[:container, :id])

    t.unittitle(path:"did/unittitle",index_as:[:displayable,:searchable])

    t.unitid(path:"did/unitid",index_as:[:searchable,:displayable])
    t.langcode(path:"did/langmaterial/language/@langcode")
    t.creator(path:"did/origination[@label='creator']/*[#{creator_fields_to_xpath}]",index_as:[:searchable,:displayable])

    # Dates
    t.unitdate_normal(path:"did/unitdate/@normal",index_as:[:displayable,:searchable,:facetable])
    t.unitdate(:path=>"did/unitdate[not(@type)]",index_as:[:searchable])
    t.unitdate_bulk(path:"did/unitdate[@type='bulk']",index_as:[:searchable])
    t.unitdate_inclusive(path:"did/unitdate[@type='inclusive']",index_as:[:searchable])

    # Fulltext in <p> under the following descriptive fields
    t.scopecontent(path:"scopecontent/p",index_as:[:searchable])
    t.bioghist(path:"bioghist/p",index_as:[:searchable])
    t.address(path:"address/p",index_as:[:searchable])
    t.appraisal(path:"appraisal/p",index_as:[:searchable])

    # Find the following wherever they exist in the tree structure under <c>
    # Matches any text within <chronlist><chronitem>, nil and blank values trimmed in to_solr
    t.chronlist(path:"chronlist/chronitem//text()",index_as:[:searchable])
    t.corpname(index_as:[:searchable,:displayable])
    t.famname(index_as:[:searchable,:displayable])
    t.function(index_as:[:searchable,:displayable])
    t.genreform(index_as:[:searchable,:displayable])
    t.geogname(index_as:[:searchable,:displayable])
    t.name(index_as:[:searchable,:displayable])
    t.occupation(index_as:[:searchable,:displayable])
    t.persname(index_as:[:searchable,:displayable])
    t.subject(index_as:[:searchable,:displayable])
    t.title(index_as:[:searchable,:displayable])
    t.note(index_as:[:searchable,:displayable])

    t.dao(path:"dao/daodesc/p",index_as:[:searchable,:displayable])
  end

  def to_solr(solr_doc = Hash.new)
    solr_doc = super(solr_doc)

    Solrizer.insert_field(solr_doc, "repository", repository_display,                           :stored_sortable, :facetable)
    Solrizer.insert_field(solr_doc, "format",     format_display,                               :facetable, :displayable)
    Solrizer.insert_field(solr_doc, "location",   location_display,                             :displayable, :sortable)
    Solrizer.insert_field(solr_doc, "creator",    get_ead_creators,                             :displayable, :facetable)
    Solrizer.insert_field(solr_doc, "name",       get_ead_names,                                :facetable, :searchable)
    Solrizer.insert_field(solr_doc, "dao",        get_ead_dao_facet,                            :facetable)
    Solrizer.insert_field(solr_doc, "place",      get_ead_places,                               :displayable, :facetable)

    Solrizer.insert_field(solr_doc, "subject",    get_ead_subject_facets,                       :facetable, :searchable)

    # Get the collection field
    Solrizer.set_field(solr_doc,    "collection", collection_name(solr_doc),                    :searchable, :displayable, :facetable)
    # Get the author field
    Solrizer.set_field(solr_doc,    "author",     author(solr_doc),                             :searchable, :displayable, :facetable)

    # Index series so we can sort by it an crate links directly into the series search
    Solrizer.set_field(solr_doc,    "series",     series_facets(solr_doc),                      :facetable)
    Solrizer.set_field(solr_doc,    "series",     series_sortable(solr_doc),                    :sortable)

    # Trim the fat from the various fields within the <chronlist>
    Solrizer.set_field(solr_doc,    "chronlist",  get_chronlist_text,                           :searchable)

    # Create the formatted Material Type facet from genreform
    Solrizer.insert_field(solr_doc, "material_type",get_material_type_facets,                   :facetable, :displayable)

    # Replace certain fields with their html-formatted equivalents
    Solrizer.set_field(solr_doc,    "unittitle",   self.term_to_html("unittitle"),              :displayable)
    # Use the unittitle as the heading
    Solrizer.insert_field(solr_doc, "heading",     self.unittitle,                              :displayable)

    # Set start and end date fields
    solr_doc.merge!(ead_unitdate_fields)

    # Set date range facet after we have start and end dates
    Solrizer.insert_field(solr_doc, "date_range",   get_date_range_facets,  :facetable)

    # Set language codes
    solr_doc.merge!(ead_language_fields)

    return solr_doc
  end
end
