class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller

  # Please be sure to impelement current_user and user_session. Blacklight depends on
  # these methods in order to perform user specific actions.

  protect_from_forgery
  layout Proc.new{ |controller| (controller.request.xhr?) ? false : "findingaids" }

  # Alias new_session_path as login_path for default devise config
  def new_session_path(scope)
    login_path
  end

  # After signing out from the local application,
  # redirect to the logout path for the Login app
  def after_sign_out_path_for(resource_or_scope)
    if ENV['SSO_LOGOUT_URL'].present?
      ENV['SSO_LOGOUT_URL']
    else
      super(resource_or_scope)
    end
  end

  # Imitate logged in user
  def current_user_dev
    @current_user ||= User.find_or_create_by(email: 'Methuselah969@library.edu', username: "Methuselah969", firstname: "Methuselah")
  end
  alias_method :current_user, :current_user_dev if Rails.env.development?

  def repositories
    @repositories ||= Findingaids::Repositories.repositories
  end
  helper_method :repositories

end
