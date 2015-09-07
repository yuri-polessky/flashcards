Rails.application.routes.draw do

  root to: 'home#index'
  resources :cards
  resources :reviews, only: [:new, :create]
  resources :decks do
    get :set_current, on: :member
  end
  resources :registrations, only: [:new, :create]
  resources :user_sessions, only: [:new, :create, :destroy]
  resource  :profile, controller: :profile, only: [:edit,:update]
  
  get  'sign_up' => 'registrations#new',     :as => :signup
  get  'login'   => 'user_sessions#new',     :as => :login
  post 'logout'  => 'user_sessions#destroy', :as => :logout

  post "oauth/callback"  => "oauths#callback"
  get  "oauth/callback"  => "oauths#callback" # for use with Github, Facebook
  get  "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider
end
