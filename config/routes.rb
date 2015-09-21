Rails.application.routes.draw do

  root to: 'guest/home#index'
  scope module: "dashboard" do
    resources :cards
    resources :reviews, only: [:new, :create]
    resources :decks do
      get :set_current, on: :member
    end
    resource  :profile, controller: :profile, only: [:edit,:update]
    delete 'logout' => 'user_sessions#destroy', :as => :logout
    resources :user_sessions, only: :destroy
  end

  scope module: "guest" do
    resources :registrations, only: [:new, :create]
    resources :user_sessions, only: [:new, :create]
    get  'sign_up' => 'registrations#new',     :as => :signup
    get  'login'   => 'user_sessions#new',     :as => :login
    post "oauth/callback"  => "oauths#callback"
    get  "oauth/callback"  => "oauths#callback" # for use with Github, Facebook
    get  "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider
  end
end
