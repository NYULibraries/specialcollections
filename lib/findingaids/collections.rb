module Findingaids
  module Collections
    def self.included(base)
    end
    
    def admin_collections_name
      "findingaids_admin_collections".to_sym
    end
    
    # Get an array of collections authorized to the current logged in user from user attributes
    #
    # * Return an empty array if user has global access, this will skip loop adding collections to solr search hence showing all
    # * If not a global admin return array of collections to add to any_of loop to solr params
    # * If the user has no access to specific collections and no global flag return an array containing nil
    #   This will add the nil collection to the search which will return nothing
    def current_user_admin_collections
      unless current_user.nil? || 
              current_user[:user_attributes].nil? ||
                current_user[:user_attributes][admin_collections_name].nil? || 
                  !(current_user[:user_attributes][admin_collections_name].is_a? Array)
          return [] if current_user[:user_attributes][admin_collections_name].include? "global" 
          return current_user[:user_attributes][admin_collections_name]  
      else    
        return [nil]    
      end
    end
    private :current_user_admin_collections

    # Find out if current_user has access to collection
    #
    # * True if current_user's admin collections is empty, this means the "global" flag is set
    # * True if collection is included in current_user's list of collection
    # * False otherwise
    def current_user_has_access_to_collection collection
      (current_user_admin_collections.empty? or current_user_admin_collections.include? collection)
    end
    private :current_user_has_access_to_collection
    alias_method :current_user_has_access_to_collection?, :current_user_has_access_to_collection
    
    # Get user collections for @user instance, cast as Array if necessary
    def user_collections
      @user = User.find(params[:id])
      @user_collections ||= (@user.user_attributes[admin_collections_name].nil?) ? [] : 
                              (@user.user_attributes[admin_collections_name].is_a? Array) ? 
                                @user.user_attributes[admin_collections_name] : [@user.user_attributes[admin_collections_name]]
    end
    private :user_collections

    # Edit authorized collection list based on submitted values
    def update_admin_collections
      unless params[:user].nil? or params[:user][admin_collections_name].nil? 
        # Loop through all submitted admin collections
        params[:user][admin_collections_name].keys.each do |collection|
          # Remove collection from list if checkbox was unchecked
          user_collections.delete(collection) unless params[:user][admin_collections_name][collection].to_i == 1
          # Add collection to list if checkbox was checked
          user_collections.push(collection) if params[:user][admin_collections_name][collection].to_i == 1 and !user_collections.include? collection
        end 
      end
    end
    private :update_admin_collections

    # Return which collections this admin user is authorized to view and edit
    #
    # If no collections have been set for this user return an empty array. 
    def collections_user_can_admin
      return [] if @user.user_attributes[admin_collections_name].nil? or !@user.user_attributes[admin_collections_name].is_a? Array
      return @user.user_attributes[admin_collections_name]
    end
    
    # Get the current collection code
    def current_collection collection_name
      @current_collection ||= tabs_info["Catalog"]["views"]["tabs"][collection_name]["admin_code"] unless collection_name.nil? or tabs_info["Catalog"]["views"]["tabs"][collection_name].nil?
    end
    
    # Sets a session variable to the user submitted collection 
    def set_session_collection
      # This redirect hijacks the "Start over" function to redirect back to the correct collection instead of the generic catalog
      redirect_to("/#{session[:collection]}") if !params[:collection].present? and session[:collection].present? and request.path == "/catalog"
      # Set session variable to local param
      # Don't set it to nil though because we don't want it to default to "all collections"
      session[:collection] = params[:collection] if params[:collection].present?
    end

    # Add the session collection to the list of submitted variables
    def add_collection_param_to_search
      # Merge collection with params only if the controller is catalog, 
      # because Bookmarks extends Catalog we need this fix
      params.merge!({:collection => session[:collection]}) if controller_name == "catalog"
    end
    
    # Get the name of the collection from the tab info, or default to blank
    #
    # * If the collection session variable was set, use that to get the collection display name from yaml
    # * If there is a current collection otherwise, use that
    # * Show blank if no collection
    def collection_name
      (session[:collection]) ? 
        tab_info["views"]["tabs"][session[:collection]]["display"] : 
          (!current_collection(params[:collection]).nil?) ? 
            tab_info["views"]["tabs"][params[:collection]]["display"] : "" 
    end

    # Collect collections admin code from YAML
    def collection_codes
      @collections ||= tabs_info["Catalog"]["views"]["tabs"].collect{|c| c[1]["admin_code"] }.push("global")
    end

  end
end