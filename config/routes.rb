Rails.application.routes.draw do
  root "home#index"

  resource :session
  resources :passwords, param: :token

  resources :characters
  resources :rooms do
    resources :conversations do
      scope module: :conversations do
        resource :completion, only: [ :create ]
      end
    end

    scope module: :rooms do
      resources :members, only: [ :index, :new, :create, :destroy ]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
