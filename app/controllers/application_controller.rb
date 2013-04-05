class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller 
  include Blacklight::Controller
  
  include Findingaids::Collections
  helper_method :collections_user_can_admin, :current_collection, :current_user_has_access_to_collection?, :collection_codes, :collection_name
  
  # Please be sure to impelement current_user and user_session. Blacklight depends on 
  # these methods in order to perform user specific actions. 
  
  protect_from_forgery
  layout "application"

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

  ########
  # TODO
  # Is there a Rails way to do the following two functions?
  # sorted gem
  #
  # Protect against SQL injection by forcing column to be an actual column name in the model
  def sort_column klass, default_column = "title_sort"
    klass.constantize.column_names.include?(params[:sort]) ? params[:sort] : default_column
  end
  protected :sort_column
  
  # Protect against SQL injection by forcing direction to be valid
  def sort_direction default_direction = "asc"
    %w[asc desc].include?(params[:direction]) ? params[:direction] : default_direction
  end
  helper_method :sort_direction
  #
  ########
  
  # Load YAML file with tabs info into Hash
  def tabs_info
    @tabs_info ||= YAML.load_file( File.join(Rails.root, "config", "tabs.yml") )
  end
  helper_method :tabs_info
  
  # Return which Hash set to use
  #
  # * Admin tabs if user is an admin and is currently in the admin view
  # * Otherwise the Catalog tabs
  def tab_info    
   return tabs_info["Admin"] if is_admin? and is_in_admin_view?
   return tabs_info["Catalog"]
  end
  helper_method :tab_info
  
end
