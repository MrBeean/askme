Rails.application.routes.draw do
  root 'users#show'

  resources :users
  resources :questions

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'show' => 'users#show'
end
