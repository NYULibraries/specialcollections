require 'items'

namespace :items do
  desc "Generates new static pages for items"
  task :generate_static_pages do
    Items.new.generate_static_pages
    puts "\e[0;32;49mJekyll site built!\e[0m"
  end
end
