require 'vcr'

VCR.configure do |c|
  c.default_cassette_options = { allow_playback_repeats: true, match_requests_on: [:method, :uri, :body], record: :once }
  c.hook_into :webmock
  c.ignore_localhost = true
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir     = 'features/cassettes'
  # c.filter_sensitive_data() {  }
end

VCR.cucumber_tags do |t|
  t.tag '@vcr', use_scenario_name: true
end
