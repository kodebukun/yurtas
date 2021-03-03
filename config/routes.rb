Rails.application.routes.draw do

  post 'mornings/print_selected', to: 'mornings#print_selected', as: 'print_selected'
  get 'mornings/print', to: 'mornings#print', as: 'mornings_print'
  resources :mornings

  resources :comments, except: [:index, :show]

  resources :likes, only: [:create, :destroy]

  get 'posts/top', to: 'posts#top', as: 'posts_top'
  resources :posts

  get 'attendances/roster', to: 'attendances#roster'
  get 'attendances/ranking', to: 'attendances#ranking'
  get 'attendances/list', to: 'attendances#list'
  get 'attendances/index', to: 'attendances#index'

  get 'materials/dosimeters', to: 'materials#dosimeters'
  get 'materials/phantoms', to: 'materials#phantoms'
  get 'materials/machines', to: 'materials#machines'
  get 'materials/index', to: 'materials#index'

  get 'manuals/index', to: 'manuals#index'

  get 'procedures/index', to: 'procedures#index'

  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  root to: 'home#top'
  get '/signup/text', to: 'home#signup_text'
  get '/about', to: 'home#about'
  get '/index', to: 'home#index'

  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
