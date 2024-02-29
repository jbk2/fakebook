Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  
  resources :users, only: [:show, :index] do
    resources :posts, only: [:new, :create, :index]
  end

  resources :follows, only: [:create, :destroy]
  
  root "posts#index"
end
