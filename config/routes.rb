Rails.application.routes.draw do
  root 'home#index'
  resources :cards do 
    post :review, on: :member
  end
end
