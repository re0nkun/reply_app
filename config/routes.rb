Rails.application.routes.draw do
  devise_for :users
  resources :users, except: [:new, :create] do
    resource :relations, only: [:create, :destroy]
  end
  # resources :relations, only: [:create, :destroy]

  resources :posts, only: [:create, :destroy]
  root :to => 'users#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
