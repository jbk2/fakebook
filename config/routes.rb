Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'

  devise_for :users, controllers: { registrations: "users/registrations" }
  
  resources :users, only: [:show, :index] do
    resources :posts, only: [:new, :create, :index]
  end

  root "posts#index"
end
