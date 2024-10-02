Rails.application.routes.draw do
  resources :products do
    post 'add_to_cart', on: :member
  end
  resources :orders, only: [:show]

  post 'checkout', to: 'products#checkout'

  root "products#index"
end
