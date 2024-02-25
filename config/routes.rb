Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: "users/registrations" }
  
  resources :users do
    resources :posts, only: [:new, :create, :index]
  end

  root "posts#index"
end
