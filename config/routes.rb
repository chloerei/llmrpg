Rails.application.routes.draw do
  resources :personas
  root "home#index"

  resource :session
  resources :passwords, param: :token

  resources :personas

  get "up" => "rails/health#show", as: :rails_health_check
end
