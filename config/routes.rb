Rails.application.routes.draw do
  root 'reviews#new'
  resources :cards do 
    post :review, on: :member
  end
  resources :reviews, only: [:new,:create]
end
