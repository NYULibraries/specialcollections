# Ead Behaviors
#
# A collection of instance methods used by our custom EadComponent and EadDocument
# modules.  They're helpful for doing fancy things with the data when it gets
# indexed into solr.

module Findingaids::Ead::Behaviors
  
  include SolrEad::Behaviors

  # Takes the publisher string from EAD and
  # * Strips non-ascii characters such as &copy;
  # * Strips leading @ sign which is sometimes erroneously instead of a copyright
  # * Strip leading year from publisher
  def format_publisher(field)
    encoding_options = {
     :invalid           => :replace,  # Replace invalid byte sequences
     :undef             => :replace,  # Replace anything not defined in ASCII
     :replace           => '',        # Use a blank for those replacements
     :universal_newline => true       # Always break lines with \n
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

  # Combine corporate and personal names into one group
  def get_ead_names
    (self.corpname + self.persname).flatten.compact.uniq.sort
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

end
