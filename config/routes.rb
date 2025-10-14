require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions", passwords: "users/passwords" }
  
  resources :users, only: [:show, :index] do
    resources :posts, only: [:new, :create, :index]
  end

  resources :posts, only: [] do
    resources :likes, only: [:create]
    resources :comments, only: [:new, :create]
  end
  
  root "posts#index"

  resources :messages, only: [:create]
  resources :follows, only: [:create, :destroy]

  get 'friends', to: 'users#friends_index'

  get 'open_conversation_card/:id', to: 'conversations#open_conversation_card', as: 'open_conversation_card'
  delete 'close_conversation_card', to: 'conversations#close_conversation_card'
  post 'message_user', to: 'conversations#find_or_create_conversation'

  get 'check_unread', to: 'conversations#check_unread', defaults: { format: :json }
  patch 'mark_all_read', to: 'conversations#mark_all_read', defaults: { format: :json }
end
