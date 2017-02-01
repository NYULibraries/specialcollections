require 'items'

Rails.application.config.after_initialize do
  Items.new.generate_static_pages
  # the strange codes give the output color
  Rails.logger.info "\e[0;32;49mJekyll site built!\e[0m"
  puts "\e[0;32;49mJekyll site built!\e[0m"
end
