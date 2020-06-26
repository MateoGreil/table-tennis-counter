Rails.application.routes.draw do
  devise_for :users

  root to: 'home#index'

  resources :games, except: :show
  resources :users, only: %i[index show]
  resources :matches
  resources :teams
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
