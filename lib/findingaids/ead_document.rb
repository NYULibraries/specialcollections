require File.join(File.dirname(__FILE__), 'ead_behaviors.rb') unless defined?(Findingaids::EadBehaviors)

class EadDocument < SolrEad::Document
  include Findingaids::EadBehaviors

  # Use the existing terminology
  #use_terminology SolrEad::Document

  # Define each term in your ead that you want put into the solr document
  set_terminology do |t|
     t.eadid
     t.corpname(:index_as=>[:facetable])
     t.famname(:index_as=>[:facetable])
     t.genreform(:index_as=>[:facetable])
     t.geogname(:index_as=>[:facetable])
     t.name(:index_as=>[:facetable])
     t.persname(:index_as=>[:facetable])
     t.subject(:index_as=>[:facetable])

     # These terms are proxied to match with Blacklight's default facets, but otherwise
     # you can remove them or rename the above facet terms to match with your solr
     # implementation.
     t.subject_geo(:proxy=>[:geogname])
     t.subject_topic(:proxy=>[:subject])

     t.title(:path=>"archdesc/did/unittitle", :index_as=>[:unstemmed, :displayable])
     t.title_filing(:path=>"titleproper", :attributes=>{ :type => "filing" }, :index_as=>[:sortable])
     t.title_num(:path=>"archdesc/did/unitid", :index_as=>[:searchable])
     t.extent(:path=>"archdesc/did/physdesc/extent")
     t.pubdate(:path=>"archdesc/did/unitdate/@normal", :index_as=>[:facetable,:displayable])
     t.unitdate(:path=>"archdesc/did/unitdate[not(@type)]", :index_as=>[:unstemmed])
     t.unitdate_bulk(:path=>"archdesc/did/unitdate[@type='bulk']", :index_as=>[:unstemmed, :displayable])
     t.unitdate_inclusive(:path=>"archdesc/did/unitdate[@type='inclusive']", :index_as=>[:unstemmed, :displayable])
     t.langdesc(:path=>"archdesc/did/langmaterial", :index_as=>[:displayable])
     t.lang(:path=>"profiledesc/langusage/language", :index_as=>[:facetable,:displayable])
     t.langcode(:path=>"did/langmaterial/language/@langcode")
     t.abstract(:path=>"archdesc/did/abstract", :index_as=>[:searchable, :displayable])
     t.sponsor(:path=>"sponsor", :index_as=>[:searchable,:displayable])

     t.collection(:proxy=>[:title], :index_as=>[:facetable])

     # General field available within archdesc
     t.acqinfo(:path=>"archdesc/acqinfo/p", :index_as=>[:searchable, :displayable])
     t.acqinfo_heading(:path=>"archdesc/acqinfo/head", :index_as=>[:displayable])
     t.bioghist(:path=>"archdesc/bioghist/p", :index_as=>[:searchable, :displayable])
     t.bioghist_heading(:path=>"archdesc/bioghist/head", :index_as=>[:displayable])
     t.custodhist(:path=>"archdesc/custodhist/p", :index_as=>[:searchable, :displayable])
     t.custodhist_heading(:path=>"archdesc/custodhist/head", :index_as=>[:displayable])
     t.phystech(:path=>"archdesc/phystech/p", :index_as=>[:searchable, :displayable])
     t.phystech_heading(:path=>"archdesc/phystech/head", :index_as=>[:displayable])
     t.relatedmaterial(:path=>"archdesc/relatedmaterial/p", :index_as=>[:searchable, :displayable])
     t.relatedmaterial_heading(:path=>"archdesc/relatedmaterial/head", :index_as=>[:displayable])
     t.separatedmaterial(:path=>"archdesc/separatedmaterial/p", :index_as=>[:searchable, :displayable])
     t.controlaccess(:path => "archdesc/controlaccess", :index_as=>[:searchable, :displayable])
     t.scopecontent(:path=>"archdesc/scopecontent/p", :index_as=>[:searchable, :displayable])
     t.scopecontent_heading(:path=>"archdesc/scopecontent/head", :index_as=>[:displayable])
     t.userestrict(:path=>"archdesc/userestrict/p", :index_as=>[:searchable, :displayable])
     t.userestrict_heading(:path=>"archdesc/userestrict/head", :index_as=>[:displayable])
     t.index(:path=>"archdesc/index", :index_as=>[:searchable, :displayable])
    
     # These are component level items indexed into the document as fulltext searchable fields
     # so Blacklight can search it at the top level. Once this simple search is done we can search
     # the components which are individually indexed by solr_ead to get additional info
     t.unittitle(:path=>"archdesc/dsc//c[@level='file']/did/unittitle", :index_as=>[:searchable])
     t.odd(:path=>"archdesc/dsc//c[@level='file']/odd", :index_as=>[:searchable])

     t.publisher(:path => "publisher", :index_as => [:searchable])
  end

  # Tweak other solr fields here.
  def to_solr(solr_doc = Hash.new)
    super(solr_doc)

    solr_doc.merge!({"publisher_display"   =>      format_publisher(self.publisher)})
    solr_doc.merge!({"repository_s"        =>      format_repository})

    solr_doc.merge!({"id"              => self.eadid.first.strip})
    solr_doc.merge!({"ead_id"          => self.eadid.first.strip})
    solr_doc.merge!({"format"          => "Archival Collection"})
    
    solr_doc.merge!({"unitdate_display" => ead_date_display})
    solr_doc.merge!({"heading_display"  => format_heading(self.title, self.title_num)})  unless self.title_num.empty?
    solr_doc.merge!({"text"             => self.ng_xml.text})
    solr_doc.merge!({"language_facet"   => get_language_from_code(self.langcode.first) })

    # Facets
    solr_doc.merge!({"genre_facet"      => self.genreform})

    # Gather persname and corpame together as  contributors_display to match what we do with MARC
    # copyt this to name_facet
    solr_doc["contributors_display"] = (self.corpname + self.persname).flatten.compact.uniq.sort
    solr_doc["name_facet"] = solr_doc["contributors_display"]

    # Split out subjects into individual terms; save original subject headings from EAD for display
    solr_doc["subject_display"] = self.subject
    new_subject_facet = Array.new
    self.subject.each do |term|
     splits = term.split(/--/)
     new_subject_facet << splits
    end
    solr_doc["subject_facet"] = new_subject_facet.flatten.compact.uniq.sort

    return solr_doc
  end

end