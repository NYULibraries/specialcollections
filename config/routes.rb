Findingaids::Application.routes.draw do

  Blacklight.add_routes(self)

  root :to => "catalog#index"

  # Create named routes for each collection specified in tabs.yml
  YAML.load_file( File.join(Rails.root, "config", "repositories.yml") )["Catalog"]["repositories"].each do |coll|
     get "#{coll[0]}" => "catalog#index", :search_field => "#{coll[1]['display']}", :repository => "#{coll[1]['display']}"
  end

  scope "admin" do
    resources :records do
      post 'upload', :on => :collection
    end
    resources :users
    delete "clear_patron_data", :to => "users#clear_patron_data"
  end

  get 'login', :to => 'user_sessions#new', :as => :login
  get 'logout', :to => 'user_sessions#destroy', :as => :logout
  get 'validate', :to => 'user_sessions#validate', :as => :validate
  resources :user_sessions

  # For EAD
  get "components/:id(/:ref)", :to => "components#index"
  get "catalog/:id/:ref", :to => "catalog#show"

  # Don't know what these are for so commenting out for now
  # Holdings
  # get "holdings/:id" => "holdings#show", :as => :holdings
  # match "*a", :to => "catalog#index", :via => [:get, :post] if Rails.env.match?("production")

end
