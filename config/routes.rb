Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'categories#index'
  get '/dashboard', to: 'dashboard#index'
  get 'users/:id/order_history', to: 'users#order_history', as: :order_history

  resources :users, :categories, :products
end
