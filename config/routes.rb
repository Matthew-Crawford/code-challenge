Rails.application.routes.draw do

  root 'main#new'
  post '/verify', to: 'main#create'
  post '/verify_bulk', to: 'main#import'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get '/signup', to: 'users#new'
  post  '/signup',  to: 'users#create'
  resources :users

  namespace :api do
   namespace :v1 do
    resources :email_verifications
   end
  end
end
