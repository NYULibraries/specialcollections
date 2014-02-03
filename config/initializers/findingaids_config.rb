# setup up empty hash to put our configuration into
config = Hash.new
# Path to ead xml
config[:ead_path] = 'public/fa'
# Maximum number of components to return before "more" link
config[:max_components] = 1000
# Pin our hash to the global Rails configuration
Rails.configuration.findingaids_config = config