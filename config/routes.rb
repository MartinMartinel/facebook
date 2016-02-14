Rails.application.routes.draw do
  devise_scope :user do
    root to: 'devise/registrations#new'
  end

  devise_for :users,
             :controllers => { :registrations => "registrations",
                               :omniauth_callbacks => "users/omniauth_callbacks" },
             :skip => [:sessions]

  resources :users,       only: :index
  resources :friendships, only: [:create, :update, :destroy]
  resources :notifications, only: [:index]

  as :user do
    get    'login'  => 'devise/sessions#new',     :as => :new_user_session
    post   'login'  => 'devise/sessions#create',  :as => :user_session
    delete 'logout' => 'devise/sessions#destroy', :as => :destroy_user_session
    get    'signup' => 'registrations#new'
  end

  get 'newsfeed/:id',        to: 'users#newsfeed',        as: :newsfeed
  get 'friends/:id',         to: 'users#friends',         as: :friends
  get 'friend_requests/:id', to: 'users#friend_requests', as: :friend_requests
  get 'find_friends/:id',    to: 'users#find_friends',    as: :find_friends
end
