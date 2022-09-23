Rails.application.routes.draw do
  devise_for :users
  root to: 'users/posts#index'

  namespace :users do
    resources :posts, path: 'home'
    resources :friendships do
      put :confirm
      put :cancel
      put :decline
      put :unfriend
    end
  end
end
