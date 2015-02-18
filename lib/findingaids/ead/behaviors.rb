##
# Ead Behaviors
#
# A collection of instance methods used by our custom EadComponent and EadDocument
# modules.  They're helpful for doing fancy things with the data when it gets
# indexed into solr.
module Findingaids::Ead::Behaviors

  # Use default behaviors
  include SolrEad::Behaviors

  # Allows us to use class methods from this module in document and component.rb
  extend ActiveSupport::Concern

  ##
  # Define Constants
  # Fields to link to in display view
  LINK_FIELDS = {
    :abstract => [:abstract],
    :admininfo => [:custodhist, :sponsor, :acqinfo, :physctech, :index],
    :dsc => [:odd, :unittitles]
  }
  #Possible creator subfields
  CREATOR_FIELDS = [:corpname, :famname, :persname]
  #
  ##

  module ClassMethods
    def creator_fields_to_xpath
      @creator_fields_to_xpath ||= CREATOR_FIELDS.map {|field| "name() = '#{field}'"}.join(" or ")
    end
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

  # Returns the language terms as string from a given three-letter code found in language_map.properties
  def get_language_from_code code, properties = Hash.new
    file = File.new(File.path(Rails.root + "config/translation_maps/language_map.properties"))
    IO.foreach(file) do |line|
      properties[$1.strip] = $2 if line =~ /([^=]*)=(.*)\/\/(.*)/ || line =~ /([^=]*)=(.*)/
    end
    properties[code].nil? ? nil : properties[code].strip
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
    get_ead_creators = CREATOR_FIELDS.map {|field| search("//origination[@label='creator']/#{field}") }
    # Flatten nested arrays into one top level array
    get_ead_creators = get_ead_creators.flatten
    # Map to the text value and remove nils
    get_ead_creators = get_ead_creators.map(&:text).compact
    return get_ead_creators
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
  def get_ead_dao_facet
    "Online Access" unless(value("//dao")).empty?
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
