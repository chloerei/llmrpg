Rails.application.routes.draw do
  root "home#index"

  resource :session, only: [ :new, :create, :destroy ]
  resource :registration, only: [ :new, :create ]
  resources :passwords, param: :token

  resources :characters
  resources :rooms do
    resources :conversations, only: [ :index, :create ]

    scope module: :rooms do
      resources :members, only: [ :index, :new, :create, :destroy ] do
        scope module: :members do
          resource :play, only: [ :create, :destroy ]
        end
      end
    end
  end

  resources :conversations, only: [ :destroy ] do
    resources :messages, only: [ :create ]
  end

  namespace :settings do
    root "home#index"

    namespace :account do
      root "home#index"
      resource :email, only: [ :show, :update ]
      resource :password, only: [ :show, :update ]
    end
    resource :preference, only: [ :show, :update ]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
