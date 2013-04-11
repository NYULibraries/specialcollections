# Load the rails application
require File.expand_path('../application', __FILE__)

ActionMailer::Base.default :from => 'no-reply@library.nyu.edu'

# Initialize the rails application
Findingaids::Application.initialize!

