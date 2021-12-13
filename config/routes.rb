Rails.application.routes.draw do

  resources :profiles
  # devise_for :users
  devise_for :users, path: 'users', :controllers => { registrations: 'devise/registrations' }

  # resources :comments
  # resources :articles
  resources :articles do
    resources :comments
  end

  # get 'home/index'
  root to: 'home#index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
