Findingaids::Application.routes.draw do
  blacklight_for :catalog
  root :to => "catalog#index"

  # Create named routes for each collection specified in the Repositories Class
  Findingaids::Repositories.repositories.each do |coll|
    get "#{coll[1]['url']}" => "catalog#index", :search_field => "#{coll[1]['url_safe_display']}", :repository => "#{coll[1]['display']}", :f => { :repository_sim => ["#{coll[1]['admin_code']}"] }
  end

  # Help resources
  get 'help/search_tips', :as => :search_tips
  get 'help/contact_information', :as => :contact_information

  # User resources for logging in
  get 'login', :to => 'user_sessions#new', :as => :login
  get 'logout', :to => 'user_sessions#destroy', :as => :logout
  get 'validate', :to => 'user_sessions#validate', :as => :validate
  resources :user_sessions
end
