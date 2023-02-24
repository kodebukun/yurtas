Rails.application.routes.draw do

  resources :user_access_points, only: [:edit, :update, :destroy]

  resources :access_points do
    collection do
      get 'admin'
    end
  end

  resources :devices

  resources :wifis, only: [:index] do
    collection do
      get 'add_device'
      get 'release_device'
    end
  end

  resources :breaches, except: [:edit]

  resources :evaluations, only: [:create, :destroy, :update]

  resources :anonymous_comments, only: [:new, :create, :destroy]

  resources :anonymous_posts, except: [:edit]

  resources :diaries

  delete 'notifications/destroy', to: 'notifications#destroy', as: 'destroy_notifications'
  resources :notifications, only: [:index]

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
      put 'ranking_update'
      patch 'ranking_update'
      get 'roster'
    end
  end

  resources :materials do
    collection do
      get 'dosimeters'
      get 'machines'
      get 'phantoms'
    end
  end

  get 'files/index'

  get 'manuals/index'

  resources :procedures, only: [:index] do
    collection do
      get 'top'
      get 'holiday_record'
      get 'holiday_change'
      get 'holiday_paid'
      get 'holiday_special'
      get 'incident'
      get 'picture_delete'
    end
  end

  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  root to: 'home#top'
  get '/signup/text', to: 'home#signup_text'
  get '/about', to: 'home#about'
  get '/index', to: 'home#index'
  get '/index_second', to: 'home#index_second'
  get '/help', to: 'home#help'
  get '/login_help', to: 'home#login_help'

  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
