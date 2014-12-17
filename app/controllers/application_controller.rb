class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller

  # Please be sure to impelement current_user and user_session. Blacklight depends on
  # these methods in order to perform user specific actions.

  protect_from_forgery
  layout Proc.new{ |controller| (controller.request.xhr?) ? false : "application" }

  # Adds authentication actions in application controller
  # Implements current_user and user_session
  require 'authpds'
  include Authpds::Controllers::AuthpdsController

  # Imitate logged in user
  def current_user_dev
    @current_user ||= User.new(:username => "admin123", :firstname => "Atila")
  end
  alias_method :current_user, :current_user_dev if Rails.env.development?

  def repositories
    @repositories ||= Findingaids::Repositories.repositories
  end
  helper_method :repositories

end
