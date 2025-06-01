Rails.application.routes.draw do
  root "home#index"

  resource :session
  resources :passwords, param: :token

  resources :personas
  resources :characters

  resources :conversations do
    scope module: :conversations do
      resources :messages
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
