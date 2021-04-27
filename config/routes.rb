Rails.application.routes.draw do


  delete 'notifications/destroy', to: 'notifications#destroy', as: 'destroy_notifications'
  resources :notifications, only: [:index]

  resources :mornings do
    collection do
      get 'print'
      post 'print_selected'
    end
  end


  resources :comments, except: [:index, :show] do
    collection do
      get 'new_morning'
    end
  end
  get 'comment/:id/edit_morning', to: 'comments#edit_morning', as: 'edit_morning_comment'

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

  get 'procedures/index'

  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  root to: 'home#top'
  get '/signup/text', to: 'home#signup_text'
  get '/about', to: 'home#about'
  get '/index', to: 'home#index'
  get '/help', to: 'home#help'
  get '/login_help', to: 'home#login_help'

  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
