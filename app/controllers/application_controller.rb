class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller

  # Please be sure to impelement current_user and user_session. Blacklight depends on
  # these methods in order to perform user specific actions.

  protect_from_forgery
  layout Proc.new{ |controller| (controller.request.xhr? || controller.request.format.json?) ? false : "findingaids" }

  # Alias new_session_path as login_path for default devise config
  def new_session_path(scope)
    login_path
  end

  # This makes sure you redirect to the correct location after passively
  # logging in or after getting sent back not logged in
  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  # After signing out from the local application,
  # redirect to the logout path for the Login app
  def after_sign_out_path_for(resource_or_scope)
    if logout_path.present?
      logout_path
    else
      super(resource_or_scope)
    end
  end

  # Imitate logged in user
  def current_user_dev
    @current_user ||= User.find_or_create_by(email: 'Methuselah969@library.edu', username: "Methuselah969", firstname: "Methuselah")
  end
  alias_method :current_user, :current_user_dev if Rails.env.development?

  private

  def logout_path
    if ENV['LOGIN_URL'].present? && ENV['SSO_LOGOUT_PATH'].present?
      "#{ENV['LOGIN_URL']}#{ENV['SSO_LOGOUT_PATH']}"
    end
  end

end
