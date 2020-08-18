Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: 'users/registrations'}

  root to: 'home#index'

  resources :games, except: :show
  get :rivalry, to: 'users#rivalry'
  resources :users, only: %i[index show], param: :slug do
    resources :games, except: :show
    resources :matchs
  end
  resources :matches
  resources :teams
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
