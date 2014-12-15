# Add the factories from RSpec
require 'factory_girl'
Cucumber::Rails::World.send(:include, FactoryGirl::Syntax::Methods)
