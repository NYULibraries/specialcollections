module BlacklightHelper
  # Make our application helper functions available to core blacklight views
  include ApplicationHelper
  include Blacklight::BlacklightHelperBehavior
  include Blacklight::SearchHistoryConstraintsHelperBehavior
  include Findingaids::Solr::CatalogHelpers::ClassMethods

  # Change link to document to link out to external guide
  def link_to_document(doc, field, opts={:counter => nil})
    if(doc.unittitle.blank?)
      label = t('search.brief_results.link_text.no_title')
    else
      field ||= document_show_link_field(doc)
      presenter_obj = index_presenter_class(doc).new(doc, self)
      label = presenter_obj.label(field, opts)
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

  def default_search_field_path
    url_for(search_state.params_for_search(
      search_field: blacklight_config.default_search_field.key,
      repository: nil,
      f: nil
    ))
  end

  ##
  # Render the name of the facet
  #
  # Overridden to account for name in format {:default=>"Keyword"}
  def render_filter_name(name)
    return "".html_safe if name.blank?
    name = (name.is_a?Hash) ? name.try(:first).try(:last) : name
    content_tag(:span, t('blacklight.search.filters.label', :label => name), :class => 'filterName')
  end

  protected

    ##
    # Context in which to evaluate blacklight configuration conditionals
    def blacklight_configuration_context
      @blacklight_configuration_context ||= Blacklight::Configuration::Context.new(self)
    end

end
