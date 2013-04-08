module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  # Show base fields and extra fields if there are occurrences
  def should_show_index_field? document, field, solr_fname
    (["ead_id","title_txt","publisher_display","abstract_txt"].include? solr_fname or
      (!params[:q].empty? and !excerpt((render_index_field_value :document => document, :field => solr_fname), params[:q]).nil?))
  end
end