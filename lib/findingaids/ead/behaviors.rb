##
# Ead Behaviors
#
# A collection of instance methods used by our custom EadComponent and EadDocument
# modules.  They're helpful for doing fancy things with the data when it gets
# indexed into solr.
module Findingaids::Ead::Behaviors

  # Use default behaviors
  include SolrEad::Behaviors

  # Include external behaviors
  include Findingaids::Ead::Behaviors::Dates

  # Allows us to use class methods from this module in document and component.rb
  extend ActiveSupport::Concern

  # Fields to link to in display view
  LINK_FIELDS = {
    :abstract => [:abstract],
    :admininfo => [:custodhist, :sponsor, :acqinfo, :physctech, :index],
    :dsc => [:odd, :unittitles]
  }
  # Places to look for names
  NAME_FIELDS = [:corpname, :famname, :persname]

  module ClassMethods
    def creator_fields_to_xpath
      @creator_fields_to_xpath ||= NAME_FIELDS.map {|field| "name() = '#{field}'"}.join(" or ")
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
  def repository_display
    if ENV['EAD'].present?
      if File.directory?(Rails.root.join(ENV['EAD']))
        return ENV['EAD'].split("\/")[-1]
      else
        return ENV['EAD'].split("\/")[-2]
      end
    end
  end

  # Returns the language term as string from a given three-letter code found in the ISO 639 gem
  def get_language_from_code code
    ISO_639.find(code).english_name if not(code.nil?)
  end

  # Combine subjets into one group from:
  #
  #   <subject></subject>
  #   <function></function>
  #   <occupation></occupation>
  def get_ead_subject_facets(subjects = Array.new)
    subjects << search("//*[local-name()='subject' or local-name()='function' or local-name() = 'occupation']")
    return clean_facets_array(subjects.flatten.map(&:text))
  end

  # Combine creators into one group looking for one or more of the following:
  #
  #   <origination label="creator">
  #     <persname></persname>
  #     <corpname></corpname>
  #     <famname></famname>
  #    </origination>
  def get_ead_creators
    get_ead_creators = NAME_FIELDS.map {|field| search("//origination[@label='creator']/#{field}") }
    # Flatten nested arrays into one top level array
    get_ead_creators = get_ead_creators.flatten
    # Map to the text value and remove nils
    get_ead_creators = get_ead_creators.map(&:text).compact
    return get_ead_creators
  end

  # getting places and scrubbing out subfield demarcators
  #
  def get_ead_places
    @get_ead_places ||= clean_facets_array(search("//geogname").map(&:text))
  end

  # Copy material type from genreform and scrub out Marc subfield demarcators
  def get_material_type_facets
    @get_material_type_facets ||= clean_facets_array(search("//genreform").map(&:text))
  end

  # Combine names into one group looking for one or more of the following:
  #
  #   <persname></persname>
  #   <corpname></corpname>
  #   <famname></famname>
  #
  # Exception: <corpname> results that are wrapped within the <repository> tag should be excluded from results
  def get_ead_names(get_ead_names = Array.new)
    NAME_FIELDS.each do |field|
      get_ead_names += search("//#{field}") unless field == :corpname
      get_ead_names += search("//*[local-name()!='repository']/#{field}") if field == :corpname
    end
    return clean_facets_array(get_ead_names.map(&:text))
  end

  # Returns a hash of lanuage fields for an EAD document or component
  def ead_language_fields(fields = Hash.new)
    language = get_language_from_code(self.langcode.first)
    unless langcode.nil?
      Solrizer.set_field(fields, "language", language, :facetable)
      Solrizer.set_field(fields, "language", language, :displayable)
    end

    return fields
  end

  #Identify if resource is available on line. Looks for
  #
  #<dao></dao>
  def get_ead_dao_facet
    I18n.t('indexer.fields.dao') unless(value("//dao")).empty?
  end

  # Replace MARC style subfield demarcators
  #
  # Usage: fix_subfield_demarcators("Subject 1 |z Sub-Subject 2") => "Subject 1 -- Sub-Subject 2"
  def fix_subfield_demarcators(value)
     value.gsub(/\|\w{1}/,"--")
  end

  # Since <chronlist><chronitem> can contain multiple levels of elements
  # we want to make sure we remove any blank or nil values
  def get_chronlist_text
    @get_chronlist_text ||= self.chronlist - ["", nil]
  end

  # Return a cleaned array of facets without marc subfields
  #
  # E.g. clean_facets_array(['FacetValue1 |z FacetValue2','FacetValue3']) => ['FacetValue1 -- FacetValue2', 'FacetValue3']
  def clean_facets_array(facets_array)
    Array(facets_array).map {|text| fix_subfield_demarcators(text) }.compact.uniq
  end

  # Wrap OM's find_by_xpath for convenience
  def search(path)
    self.find_by_xpath(path)
  end

  def value(path)
    search(path).text
  end

end

# Override to add parent_unitid
SolrEad::Behaviors.module_eval do
  def additional_component_fields(node, addl_fields = Hash.new)
    addl_fields["id"]                                                        = [node.xpath("//eadid").text, node.attr("id")].join
    addl_fields[Solrizer.solr_name("ead", :stored_sortable)]                 = node.xpath("//eadid").text
    addl_fields[Solrizer.solr_name("parent", :stored_sortable)]              = node.parent.attr("id") unless node.parent.attr("id").nil?
    addl_fields[Solrizer.solr_name("parent", :displayable)]                  = parent_id_list(node)
    addl_fields[Solrizer.solr_name("parent_unittitles", :displayable)]       = parent_unittitle_list(node)
    addl_fields[Solrizer.solr_name("parent_unittitles", :searchable)]        = parent_unittitle_list(node)
    addl_fields[Solrizer.solr_name("component_level", :type => :integer)]    = parent_id_list(node).length + 1
    addl_fields[Solrizer.solr_name("component_children", :type => :boolean)] = component_children?(node)
    addl_fields[Solrizer.solr_name("collection", :facetable)]                = node.xpath("//archdesc/did/unittitle").text
    addl_fields[Solrizer.solr_name("collection", :displayable)]              = node.xpath("//archdesc/did/unittitle").text
    addl_fields[Solrizer.solr_name("collection_unitid", :displayable)]       = node.xpath("//archdesc/did/unitid").text
    return addl_fields
  end
end
