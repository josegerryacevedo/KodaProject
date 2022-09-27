Rails.application.routes.draw do
  devise_for :users
  root to: 'users/posts#index'

  namespace :users do
    resources :posts, path: 'home' do
      resources :comments, except: :show
    end
    resources :friendships do
      put :confirm, :cancel, :decline, :unfriend
    end
  end
end
