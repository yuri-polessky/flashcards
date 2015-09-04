Rails.application.routes.draw do
  root 'reviews#new'
  resources :cards do
    post :review, on: :member
  end
  resources :reviews, only: [:new, :create]
  resources :users, only: [:new, :create, :edit, :update]
  resources :user_sessions, only: [:new, :create, :destroy]
  
  get  'sign_up' => 'users#new',             :as => :signup
  get  'login'   => 'user_sessions#new',     :as => :login
  post 'logout'  => 'user_sessions#destroy', :as => :logout

  post "oauth/callback"  => "oauths#callback"
  get  "oauth/callback"  => "oauths#callback" # for use with Github, Facebook
  get  "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider
end
