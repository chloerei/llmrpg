Rails.application.routes.draw do
  root "home#index"

  resource :session
  resources :passwords, param: :token

  resources :characters
  resources :rooms do
    scope module: :rooms do
      resources :members, only: [ :index, :new, :create, :destroy ] do
        scope module: :members do
          resource :play, only: [ :create, :destroy ]
        end
      end
    end
  end

  resources :conversations, only: [ :destroy ] do
    scope module: :conversations do
      resource :completion, only: [ :create ]
    end
  end

  namespace :settings do
    root "home#index"

    namespace :account do
      root "home#index"
      resource :email, only: [ :show, :update ]
      resource :password, only: [ :show, :update ]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
