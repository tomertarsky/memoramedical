Rails.application.routes.draw do
  resources :agent_configs
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Root route - landing page
  root "leads#index"
  
  # Lead routes
  resources :leads, only: [:index, :create]

  # AI chat page with voice call
  get "chat" => "leads#chat", as: :chat
  
  # Research page
  get "research" => "research#index", as: :research
  
  # API routes
  namespace :api do
    post 'retell_access_token', to: 'retell#access_token'
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
