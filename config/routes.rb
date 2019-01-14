Rails.application.routes.draw do
  resources :clock_events, only: [:index, :new, :create, :edit, :update]

  root to: 'clock_events#new' 
end
