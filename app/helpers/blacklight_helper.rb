module BlacklightHelper
  # Make our application helper functions available to core blacklight views
  include ApplicationHelper
  include Blacklight::BlacklightHelperBehavior
  include Findingaids::Solr::CatalogHelpers::ClassMethods

  # delegate :blacklight_config, to: CatalogController

  # Change link to document to link out to external guide
  def link_to_document(doc, field, opts={:counter => nil})
    if(doc.unittitle.blank?)
      label=t('search.brief_results.link_text.no_title')
    else
      field ||= document_show_link_field(doc)
      label=presenter(doc).render_document_index_label field, opts
    end
    link_to_findingaid(doc, label)
  end

  def sanitize_search_params(params)
    params.permit(:q, :f => whitelisted_facets)
  rescue NoMethodError => e
    params
  end

  def whitelisted_facets
    @whitelisted_facets ||= Hash[facet_fields.map(&:first).map(&:last).map {|f| ["#{f}_sim".to_sym, []]}]
  end

  def render_bookmarks_control?
    has_user_authentication_provider? and current_or_guest_user.present?
  end

  protected

    ##
    # Context in which to evaluate blacklight configuration conditionals
    def blacklight_configuration_context
      @blacklight_configuration_context ||= Blacklight::Configuration::Context.new(self)
    end

end
