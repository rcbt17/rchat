Rails.application.routes.draw do
  get "messages/create"
  get "pages/home"
  resource :session
  resources :passwords, param: :token
  resource :registration, only: %i[new create]
  resources :chatrooms, only: %i[new create show index] do
    resources :messages, only: :create
  end
  get "manage_chatrooms", to: "chatrooms#manage"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root to: "pages#home"
end
