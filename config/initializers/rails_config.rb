RailsConfig.setup do |config|
  config.const_name = "Settings"
end
ActiveSupport.on_load(:before_initialize) do
  # Add other global settings files
  other_files = ["institutions", "sfx_databases", "solr", "sunspot", "capistrano", "authpds", "newrelic", "#{Rails.env}"]
  RailsConfig.load_and_set_settings(
    Rails.root.join("config", "settings.yml").to_s,
    *other_files.collect { |setting| Rails.root.join("config", "settings", "#{setting}.yml").to_s },
    Rails.root.join("config", "settings.local.yml").to_s)
end