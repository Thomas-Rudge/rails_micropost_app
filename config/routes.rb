Rails.application.routes.draw do
  resources :users, except: [:new, :create]

  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'

  get '/help',    to: 'static_pages#help'
  get '/about',   to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  root 'static_pages#home'
end
