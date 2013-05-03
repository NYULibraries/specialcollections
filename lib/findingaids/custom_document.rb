require File.join(File.dirname(__FILE__), 'record.rb') unless defined?(Findingaids::Record)

class CustomDocument < SolrEad::Document
 include Findingaids::Record

 set_terminology do |t|
    #t.root(:path=>"ead")

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
    t.title_num(:path=>"archdesc/did/unitid", :index_as=>[:searchable, :displayable])
    t.extent(:path=>"archdesc/did/physdesc/extent")
    t.pubdate(:path=>"archdesc/did/unitdate/@normal", :index_as=>[:facetable,:displayable])
    t.unitdate(:path=>"archdesc/did/unitdate[not(@type)]", :index_as=>[:unstemmed])
    t.unitdate_bulk(:path=>"archdesc/did/unitdate[@type='bulk']", :index_as=>[:unstemmed])
    t.unitdate_inclusive(:path=>"archdesc/did/unitdate[@type='inclusive']", :index_as=>[:unstemmed])
    t.langdesc(:path=>"archdesc/did/langmaterial", :index_as=>[:displayable])
    t.lang(:path=>"profiledesc/langusage/language", :index_as=>[:facetable,:displayable])
    t.langcode(:path=>"did/langmaterial/language/@langcode")
    t.abstract(:path=>"archdesc/did/abstract", :index_as=>[:searchable])
    t.sponsor(:path=>"sponsor", :index_as=>[:searchable,:displayable])

    t.collection(:proxy=>[:title], :index_as=>[:facetable])

    # General field available within archdesc
    t.acqinfo(:path=>"archdesc/acqinfo/p", :index_as=>[:searchable])
    t.acqinfo_heading(:path=>"archdesc/acqinfo/head", :index_as=>[:displayable])
    t.bioghist(:path=>"archdesc/bioghist/p", :index_as=>[:searchable])
    t.bioghist_heading(:path=>"archdesc/bioghist/head", :index_as=>[:displayable])
    t.custodhist(:path=>"archdesc/custodhist/p", :index_as=>[:searchable])
    t.custodhist_heading(:path=>"archdesc/custodhist/head", :index_as=>[:displayable])
    t.phystech(:path=>"archdesc/phystech/p", :index_as=>[:searchable])
    t.phystech_heading(:path=>"archdesc/phystech/head", :index_as=>[:displayable])
    t.relatedmaterial(:path=>"archdesc/relatedmaterial/p", :index_as=>[:searchable])
    t.relatedmaterial_heading(:path=>"archdesc/relatedmaterial/head", :index_as=>[:displayable])
    t.separatedmaterial(:path=>"archdesc/separatedmaterial/p", :index_as=>[:searchable])
    t.controlaccess(:path => "archdesc/controlaccess", :index_as=>[:searchable])
    t.scopecontent(:path=>"archdesc/scopecontent/p", :index_as=>[:searchable])
    t.scopecontent_heading(:path=>"archdesc/scopecontent/head", :index_as=>[:displayable])
    t.userestrict(:path=>"archdesc/userestrict/p", :index_as=>[:searchable])
    t.userestrict_heading(:path=>"archdesc/userestrict/head", :index_as=>[:displayable])
    t.unittitle(:path=>"archdesc/dsc//c[@level='file']/did/unittitle", :index_as=>[:searchable])
    t.odd(:path=>"archdesc/dsc//c[@level='file']/odd", :index_as=>[:searchable])
    t.index(:path=>"archdesc/index", :index_as=>[:searchable])

    t.publisher(:path => "publisher", :index_as => [:searchable])
 end

 # Optionally, you may tweak other solr fields here.  Otherwise, you can leave this
 # method out of your definition.
 def to_solr(solr_doc = Hash.new)
   super(solr_doc)
   solr_doc.merge!({"publisher_unstem_search" =>      format_publisher(self.publisher)})
   solr_doc.merge!({"repository_s" =>                 format_repository})
   solr_doc.merge!({"heading_t" =>                    ("Guide to the " + self.title.first + " (" + self.title_num.first + ")")}) unless self.title_num.empty?
 end

end