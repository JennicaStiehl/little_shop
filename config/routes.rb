Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  # Authentication Paths
  get '/login', to: 'sessions#new', as: :login
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy', as: :logout
  get '/register', to: 'users#new', as: :registration
  post '/register', to: 'users#create'

  # Cart Paths
  get '/cart', to: 'cart#show'
  post '/cart/items/:id', to: 'cart#increment', as: :cart_item
  patch '/cart/items/:id', to: 'cart#decrement'
  delete '/cart', to: 'cart#destroy', as: :empty_cart
  delete '/cart/items/:id', to: 'cart#remove_item', as: :remove_item

  resources :items, only: [:index, :show], param: :slug
  resources :merchants, only: [:index], param: :slug

namespace :merchants do
    resources :items, only: [:show, :index], param: :slug do
      resources :bulk_discounts
    end
  end

  # User Profile Paths
  get '/profile', to: 'users#show', as: :profile
  get '/profile/edit', to: 'users#edit', as: :edit_profile
  patch '/profile/edit', to: 'users#update'
  namespace :profile do
    resources :orders, only: [:index, :show, :destroy, :create]
  end

  namespace :dashboard do
    get '/', to: 'dashboard#index'

    resources :items, param: :slug
    patch '/items/:slug/enable', to: 'items#enable', as: 'enable_item'
    patch '/items/:slug/disable', to: 'items#disable', as: 'disable_item'
    put '/order_items/:order_item_id/fulfill', to: 'orders#fulfill', as: 'fulfill_order_item'
    resources :orders, only: [:show]
  end

  namespace :admin do
    get '/dashboard', to: 'dashboard#index'

    patch '/merchants/:id/downgrade', to: 'merchants#downgrade', as: :downgrade_merchant
    patch '/users/:id/upgrade', to: 'users#upgrade', as: :upgrade_user
    resources :users, only: [:index, :show], param: :slug

    resources :orders, only: [:show]
    patch '/orders/:order_id/ship', to: 'orders#ship', as: 'order_ship'

    patch '/merchants/:id/enable', to: 'merchants#enable', as: :enable_merchant
    patch '/merchants/:id/disable', to: 'merchants#disable', as: :disable_merchant
    resources :merchants, only: [:show], param: :slug do
      resources :items, only: [:new]
      resources :items, only: [:index]
      resources :orders, only: [:show]
    end
  end

end
