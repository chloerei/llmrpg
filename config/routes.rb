Rails.application.routes.draw do
  resources :conversations
  root "home#index"

  resource :session
  resources :passwords, param: :token

  resources :personas
  resources :characters

  get "up" => "rails/health#show", as: :rails_health_check
end
