require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  devise_for :users, controllers: { registrations: "users/registrations" }
  
  resources :users, only: [:show, :index] do
    resources :posts, only: [:new, :create, :index]
  end

  resources :conversations, only: [:show, :create]
  delete 'close_conversation_card', to: 'conversations#close_conversation_card'
  post 'message_user', to: 'conversations#find_or_create_conversation'

  resources :messages, only: [:create]
  
  resources :posts, only: [] do
    resources :likes, only: [:create]
    resources :comments, only: [:new, :create]
  end

  resources :follows, only: [:create, :destroy]
  
  root "posts#index"
end
