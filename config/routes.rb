Rails.application.routes.draw do
  root "home#index"

  resource :session
  resources :passwords, param: :token

  resources :personas
  resources :characters
  resources :rooms do
    resources :conversations do
      scope module: :conversations do
        resource :completion, only: [ :create ]
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
