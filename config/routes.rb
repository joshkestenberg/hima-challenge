Rails.application.routes.draw do
  resources :clock_events, only: [:index, :create, :update]
  get 'clock_events/home', to: 'clock_events#home'
  get 'clock_events/punch_clock', to: 'clock_events#punch_clock', as: 'punch_clock'

  root to: 'clock_events#home'
end
