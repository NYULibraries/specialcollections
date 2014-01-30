require File.join(File.dirname(__FILE__), 'ead_behaviors.rb') unless defined?(Findingaids::EadBehaviors)

class EadComponent < SolrEad::Component
  include Findingaids::EadBehaviors

  # Use the existing terminology
  #use_terminology SolrEad::Component
  
  set_terminology do |t|
    t.root(:path=>"c")
    t.ref_(:path=>"/c/@id")
    t.level(:path=>"/c/@level", :index_as=>[:facetable])

    t.title(:path=>"unittitle", :attributes=>{ :type => :none }, :index_as=>[:displayable,:searchable])
    t.unitdate(:index_as=>[:displayable])

    # Facets
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

    # Item
    t.container {
      t.label(:path => {:attribute=>"label"})
      t.type(:path => {:attribute=>"type"})
      t.id(:path => {:attribute=>"id"})
    }
    t.container_label(:proxy=>[:container, :label])
    t.container_type(:proxy=>[:container, :type])
    t.container_id(:proxy=>[:container, :id])
    t.material(:proxy=>[:container, :label], :index_as=>[:facetable])
    t.physdesc(:path=>"did/physdesc[not(dimensions)]", :index_as=>[:displayable])
    t.dimensions(:path=>"did/physdesc/dimensions", :index_as=>[:displayable])
    t.langcode(:path=>"did/langmaterial/language/@langcode")
    t.language(:path=>"did/langmaterial", :index_as=>[:displayable])

    # Description
    t.accessrestrict(:path=>"accessrestrict/p", :index_as=>[:searchable,:displayable])
    t.accessrestrict_heading(:path=>"accessrestrict/head")
    t.accruals(:path=>"accruals/p", :index_as=>[:searchable,:displayable])
    t.accruals_heading(:path=>"accruals/head")
    t.acqinfo(:path=>"acqinfo/p", :index_as=>[:searchable,:displayable])
    t.acqinfo_heading(:path=>"acqinfo/head")
    t.altformavail(:path=>"altformavail/p", :index_as=>[:searchable,:displayable])
    t.altformavail_heading(:path=>"altformavail/head")
    t.appraisal(:path=>"appraisal/p", :index_as=>[:searchable,:displayable])
    t.appraisal_heading(:path=>"appraisal/head")
    t.arrangement(:path=>"arrangement/p", :index_as=>[:searchable,:displayable])
    t.arrangement_heading(:path=>"arrangement/head")
    t.custodhist(:path=>"custodhist/p", :index_as=>[:searchable,:displayable])
    t.custodhist_heading(:path=>"custodhist/head")
    t.fileplan(:path=>"fileplan/p", :index_as=>[:searchable,:displayable])
    t.fileplan_heading(:path=>"fileplan/head")
    t.originalsloc(:path=>"originalsloc/p", :index_as=>[:searchable,:displayable])
    t.originalsloc_heading(:path=>"originalsloc/head")
    t.phystech(:path=>"phystech/p", :index_as=>[:searchable,:displayable])
    t.phystech_heading(:path=>"phystech/head")
    t.processinfo(:path=>"processinfo/p", :index_as=>[:searchable,:displayable])
    t.processinfo_heading(:path=>"processinfo/head")
    t.relatedmaterial(:path=>"relatedmaterial/p", :index_as=>[:searchable,:displayable])
    t.relatedmaterial_heading(:path=>"relatedmaterial/head")
    t.separatedmaterial(:path=>"separatedmaterial/p", :index_as=>[:searchable,:displayable])
    t.separatedmaterial_heading(:path=>"separatedmaterial/head")
    t.scopecontent(:path=>"scopecontent/p", :index_as=>[:searchable,:displayable])
    t.scopecontent_heading(:path=>"scopecontent/head")
    t.userestrict(:path=>"userestrict/p", :index_as=>[:searchable,:displayable])
    t.userestrict_heading(:path=>"userestrict/head")

    # <odd> nodes
    # These guys depend on what's in <head> so we do some xpathy stuff...
    t.note(:path=>'odd[./head="General note"]/p', :index_as=>[:searchable,:displayable])
    t.accession(:path=>'odd[./head[starts-with(.,"Museum Accession")]]/p', :index_as=>[:searchable,:displayable])
    t.print_run(:path=>'odd[./head[starts-with(.,"Limited")]]/p', :index_as=>[:searchable,:displayable])
    
    t.odd(:path=>"odd", :index_as=>[:searchable, :displayable])
  end

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)

    # Alter our heading display if the title is blank
    #solr_doc["heading_display"] = (solr_doc["heading_display"] + self.unitdate.first) if self.title.first.blank?
    solr_doc.merge!({"location_display"        => self.location_display })
    solr_doc.merge!({"repository_s"            =>      format_repository})
    #solr_doc.merge!({"accession_unstem_search" => ead_accession_range(self.accession.first)})
    solr_doc.merge!({"text"                    => [self.title, solr_doc["parent_unittitles_display"]].flatten })
    solr_doc.merge!({"language_facet"          => get_language_from_code(self.langcode.first) })
    solr_doc.merge!({"format" => "Archival Item"})
    
    solr_doc["parent_unittitles_display"].length > 0 ? solr_doc.merge!({"heading_display" => [ solr_doc["parent_unittitles_display"], self.title.first].join(" >> ")  }) :       solr_doc.merge!({"heading_display" => self.title.first  }) unless solr_doc["parent_unittitles_display"].blank?
    
    solr_doc.merge!({"ref_id" => self.ref.first.strip}) unless self.ref.blank?
    
    return solr_doc
  end

  def location_display(locations = Array.new)
    self.container_id.each do |id|
      line = String.new
      line << (self.find_by_xpath("//container[@id = '#{id}']/@type").text + ": ")
      line << self.find_by_xpath("//container[@id = '#{id}']").text
      sub_containers = Array.new
      self.find_by_xpath("//container[@parent = '#{id}']").each do |sub|
        sub_containers << sub.attribute("type").text + ": " + sub.text
      end
      line << (", " + sub_containers.join(", ") ) unless sub_containers.empty?
      line << " (" + self.find_by_xpath("//container[@id = '#{id}']/@label").text + ")"
      locations << line
    end
    return locations
  end

end