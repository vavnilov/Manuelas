Rails.application.routes.draw do

  get 'users/buy_or_sell', to: 'users#buy_or_sell'
  get "/signup", to: "users#new"
  get "/login", to: 'sessions#new'
  post "/login", to: "sessions#create"
  post '/logout', to: 'session#destroy'
  delete "/logout", to: "sessions#destroy"
  resources :products

  # get 'users/cart', to: 'users#cart'
  post 'user_products/:id/add_cart', to: "user_products#add_cart", as: "add"
  post '/users/cart', to: 'users#checkout'
  get '/users/confirmation', to: 'users#confirmation'

  get 'users/delete_cart', to: 'users#delete_cart'

  resources :user_products

  resources :users, only: [:show, :edit, :update, :create, :destroy]

  root 'users#welcome'

  # # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
