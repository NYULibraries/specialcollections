Findingaids::Application.routes.draw do

  mount Blacklight::Engine => '/'
  mount BlacklightAdvancedSearch::Engine => '/'

  root to: "catalog#index"
    concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  # mount Blacklight::Engine => '/'
  # mount BlacklightAdvancedSearch::Engine => '/'

  # blacklight_for :catalog
  # concern :searchable, Blacklight::Routes::Searchable.new

  get 'advanced' => 'advanced#index', as: 'advanced_search'

  # Create named routes for each collection specified in the Repositories Class
  Findingaids::Repositories.repositories.each do |coll|
    get "#{coll[1]['url']}" => "catalog#index", :search_field => "#{coll[1]['url_safe_display']}", :repository => "#{coll[1]['display']}", :f => { :repository_sim => ["#{coll[1]['admin_code']}"] }
  end

  # Help resources
  get 'help/search_tips', :as => :search_tips
  get 'help/contact_information', :as => :contact_information

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get 'logout', to: 'devise/sessions#destroy', as: :logout
    get 'login', to: redirect { |params, request| "#{Rails.application.config.relative_url_root}/users/auth/nyulibraries?#{request.query_string}" }, as: :login
  end
end
