Rails.application.routes.draw do
  resources :users, except: [:new, :create, :update]
  resources :account_activations, only: [:edit]

  get   '/signup',    to: 'users#new'
  post  '/signup',    to: 'users#create'
  patch '/users/:id', to: 'users#update', as: 'update_user'

  get '/help',    to: 'static_pages#help'
  get '/about',   to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  root 'static_pages#home'
end
