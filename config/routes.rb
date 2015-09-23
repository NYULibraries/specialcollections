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

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get 'logout', to: 'devise/sessions#destroy', as: :logout
    get 'login', to: redirect { |params, request| "#{Rails.application.config.relative_url_root}/users/auth/nyulibraries?#{request.query_string}" }, as: :login
  end
end
