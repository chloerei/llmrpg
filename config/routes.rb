Rails.application.routes.draw do
  root "home#index"

  resource :session
  resources :passwords, param: :token

  resources :characters
  resources :rooms do
    scope module: :rooms do
      resources :conversations do
        scope module: :conversations do
          resource :completion, only: [ :create ]
        end
      end

      resources :members, only: [ :index, :new, :create, :destroy ] do
        scope module: :members do
          resource :play, only: [ :create, :destroy ]
        end
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
