Rails.application.routes.draw do
  devise_for :users
  root to: 'users/posts#index'

  namespace :users do
    resources :posts
  end
end
