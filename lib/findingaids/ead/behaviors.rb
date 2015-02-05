# Ead Behaviors
#
# A collection of instance methods used by our custom EadComponent and EadDocument
# modules.  They're helpful for doing fancy things with the data when it gets
# indexed into solr.

module Findingaids::Ead::Behaviors

  include SolrEad::Behaviors

  # Config mapping for linking to specific pages from found text in Solr fields
  LINK_FIELDS = {
    :abstract => [:abstract],
    :admininfo => [:custodhist, :sponsor, :acqinfo, :physctech, :index],
    :dsc => [:odd, :unittitles]
  }

  # Takes the publisher string from EAD and
  # * Strips non-ascii characters such as &copy;
  # * Strips leading @ sign which is sometimes erroneously instead of a copyright
  # * Strip leading year from publisher
  def format_publisher(field)
    encoding_options = {
     :invalid           => :replace,  # Replace invalid byte sequences
     :undef             => :replace,  # Replace anything not defined in ASCII
     :replace           => '',        # Use a blank for those replacements
     :UNIVERSAL_NEWLINE_DECORATOR => true       # Always break lines with \n
    }
    return (field.first.encode Encoding.find('ASCII'), encoding_options).strip.gsub(/\A@/,'').strip.gsub(/\A\d{4}/,'').strip
  end

  # Pulls the repository from the directory title when indexing from the rake task
  #
  #   rake findingaids:ead:index EAD=data/repos/test.xml
  #   rake findingaids:ead:index EAD=data/repos/
  #
  # Would both result in:
  #
  #   "repos"
  def format_repository
    if ENV['EAD'].present?
      if File.directory?(Rails.root.join(ENV['EAD']))
        return ENV['EAD'].split("\/")[-1]
      else
        return ENV['EAD'].split("\/")[-2]
      end
    end
  end

  # Formats multiple data fields into a single field for display
  def ead_date_display(parts = Array.new)
    unless self.unitdate.empty?
      parts << self.unitdate
    else
      unless self.unitdate_inclusive.empty? and self.unitdate_bulk.empty?
        parts << "Inclusive,"
        parts << self.unitdate_inclusive
        unless self.unitdate_bulk.empty?
          parts << ";"
          parts << self.unitdate_bulk
        end
      end
    end
    return parts.join(" ")
  end

  # Returns the language term as string from a given three-letter code found in the ISO 639 gem
  def get_language_from_code code
    iso_lang_code = ""
    iso = ISO_639.search(code) 
    #returns an array of arrays 
    iso.each_index{|la|
      iso[la].each{|l|
      #if code is found in language array of arrays
        if l == code
          #the ISO English equivalent of the code or the language
          #always in the 4th position of the array
          iso_lang_code = iso[la][3]
          #breaking loop if match found 
          break
        end
      }
           
    }
    iso_lang_code

  end

  # Split-up subject terms like we do for our marc records
  def get_ead_subject_facets terms = Array.new
    self.subject.each do |term|
      splits = term.split(/--/)
      terms << splits
    end
    return terms.flatten.compact.uniq.sort
  end

  # Combine creators into one group looking for one or more of the following:
  #
  #   <origination label="creator">
  #     <persname></persname>
  #     <corpname></corpname>
  #     <famname></famname>
  #    </origination>
  def get_ead_creators
    get_ead_creators = (search("//origination[@label='creator']/corpname") + search("//origination[@label='creator']/persname") + search("//origination[@label='creator']/famname"))
    get_ead_creators.map(&:text).flatten.compact.uniq.sort
  end

  # getting places and scrubbing out subfield demarcators
  # 
  def get_ead_places
    @get_ead_places ||= search("//geogname").map {|field| fix_subfield_demarcators(field.text) }.compact.uniq.sort
  end

  # Combine names into one group looking for one or more of the following:
  #
  #   <persname></persname>
  #   <corpname></corpname>
  #   <famname></famname>
  def get_ead_names
    get_ead_names = (search("//corpname") + search("//persname") + search("//famname"))
    get_ead_names.map(&:text).flatten.compact.uniq.sort
  end

  # Returns a hash of lanuage fields for an EAD document or component
  def ead_language_fields fields = Hash.new
    language = get_language_from_code(self.langcode.first)
    unless langcode.nil?
      Solrizer.set_field(fields, "language", language, :facetable)
      Solrizer.set_field(fields, "language", language, :displayable)
    end
    
    return fields
  end

  #Identify if resource is availble on line. Looks for
  #
  #<dao></dao>
  def  get_ead_dao_facet
     unless(value("//dao")).empty?
       "Online Access"
     end
  end

  # Replace MARC style subfield demarcators
  #
  # Usage: fix_subfield_demarcators("Subject 1 |z Sub-Subject 2") => "Subject 1 -- Sub-Subject 2"
  def fix_subfield_demarcators(value)
     value.gsub(/\|\w{1}/,"--")
  end
  
  # Wrap OM's find_by_xpath for convenience
  def search(path)
    self.find_by_xpath(path)
  end

  def value(path)
    search(path).text
  end

end
