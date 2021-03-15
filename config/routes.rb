Rails.application.routes.draw do

  resources :mornings do
    collection do
      get 'print'
      post 'print_selected'
    end
  end

  resources :comments, except: [:index, :show]

  resources :likes, only: [:create, :destroy]

  resources :work_posts, except: [:show] do
    collection do
      get 'top'
    end
  end

  resources :department_posts, except: [:show] do
    collection do
      get 'top'
    end
  end

  resources :posts do
    collection do
      get 'top'
    end
  end

  resource :attendances, except: [:edit, :update, :destroy] do
    collection do
      get 'menu'
      get 'list'
      get 'ranking'
      get 'roster'
    end
  end

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
