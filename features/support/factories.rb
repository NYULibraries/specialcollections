# Add the factories from RSpec
require 'factory_bot'
Cucumber::Rails::World.send(:include, FactoryBot::Syntax::Methods)
