# This puts the request id and session id as prefix values for each log entry.
# This helps aggregate papertrail logs. These will be prepended to your Rails
# logging messages
# Thanks to https://gist.github.com/soultech67/67cf623b3fbc732291a2
Rails.application.config.log_tags = [
  lambda { |request| "#{request.uuid}"[0..15] },
  lambda { |request| "#{request.cookie_jar["_web_session"]}"[0..15] },
]
