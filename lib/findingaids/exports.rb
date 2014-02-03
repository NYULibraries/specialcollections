# A Blacklight::Solr::Document::Extension that allows us to export the solr document in different formats

module Findingaids::Exports
  def self.extended(document)
    Findingaids::Exports.register_export_formats( document )
  end

  def self.register_export_formats(document)
    document.will_export_as(:xml,   "text/xml")
    document.will_export_as(:xhtml, "text/html")
  end

  def export_as_ead
    file = File.join(Rails.root, Rails.configuration.findingaids_config[:ead_path], (self.id.gsub!(/-/,".") + "-ead.xml"))
    File.exists?(file) ? File.new(file).read : export_as_dc_xml
  end

  def export_as_complete_finding_aid
    file = File.join(Rails.root, Rails.configuration.findingaids_config[:ead_path], (self.id + "_full.html"))
    File.exists?(file) ? File.new(file).read : export_as_html
  end

  # This will override Blacklight's default of exporting .xml as opensearch xml 
  alias_method :export_as_xml, :export_as_ead
  alias_method :export_as_xhtml, :export_as_complete_finding_aid

end
