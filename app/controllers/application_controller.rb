class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller 
  include Blacklight::Controller
  
  # Please be sure to impelement current_user and user_session. Blacklight depends on 
  # these methods in order to perform user specific actions. 
  
  protect_from_forgery
  layout Proc.new{ |controller| (controller.request.xhr?) ? false : "application" }

  # Adds authentication actions in application controller
  require 'authpds'
  include Authpds::Controllers::AuthpdsController
  
  # If user is an admin pass back true, otherwise redirect to root
  def authenticate_admin
    if !is_admin?
      redirect_to(root_path) and return
    else
      return true
    end
  end
  protected :authenticate_admin
  
  # Imitate logged in admin in dev
  def current_user_dev
    @current_user ||= User.find_by_username("global_admin")
  end
  alias_method :current_user, :current_user_dev if Rails.env == 'development'
  
  # Find out if the user is an admin or not based on flag
  def is_admin
  	if current_user.nil? or !current_user.user_attributes[:findingaids_admin]
      return false
    else
      return true
    end
  end
  alias :is_admin? :is_admin
  helper_method :is_admin?
  
  # Return boolean matching the url to find out if we are in the admin view
  def is_in_admin_view
    !request.path.match("admin").nil?
  end
  alias :is_in_admin_view? :is_in_admin_view
  helper_method :is_in_admin_view?

  # Load YAML file with repos info into Hash
  def repositories_info
    @repositories_info ||= YAML.load_file( File.join(Rails.root, "config", "repositories.yml") )
  end
  helper_method :repositories_info
  
  # Return which Hash set to use
  #
  # * Return the Catalog repositories
  def repository_info    
   return repositories_info["Catalog"]
  end
  helper_method :repository_info
  
end
