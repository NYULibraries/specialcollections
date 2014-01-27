require File.join(File.dirname(__FILE__), 'ead_behaviors.rb') unless defined?(Findingaids::EadBehaviors)

class EadDocument < SolrEad::Document
  include Findingaids::EadBehaviors

  # Use the existing terminology
  use_terminology SolrEad::Document

  # Define each term in your ead that you want put into the solr document
  extend_terminology do |t|
    # General field available within archdesc
    t.controlaccess(:path => "archdesc/controlaccess", :index_as=>[:searchable])
    t.index(:path=>"archdesc/index", :index_as=>[:searchable])

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
    solr_doc.merge!({
     "publisher_unstem_search"    =>      format_publisher(self.publisher),
     "repository_s"               =>      format_repository
    })
    solr_doc.merge!({"heading_t"   =>      format_heading(self.title, self.title_num)})  unless self.title_num.empty?

    solr_doc.merge!({"format"           => "Archival Collection"})
    solr_doc.merge!({"unitdate_display" => ead_date_display})
    solr_doc.merge!({"text"             => self.ng_xml.text})
    solr_doc.merge!({"language_facet"   => get_language_from_code(self.langcode.first) })

    # Facets
    solr_doc.merge!({"genre_facet"         => self.genreform})

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