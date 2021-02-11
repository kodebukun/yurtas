Rails.application.routes.draw do

  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  root to: 'home#top'
  get '/signup/text', to: 'home#signup_text'
  get '/about', to: 'home#about'
  get '/index', to: 'home#index'

  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
