FactoryGirl.define do
  factory :blacklight_config, class: Blacklight::Configuration do
    skip_create
    initialize_with {
      new.configure do |config|
        config.index.title_field = "heading_ssm"
        config.index.display_type_field = "format_ssm"
      end
    }
  end
end
