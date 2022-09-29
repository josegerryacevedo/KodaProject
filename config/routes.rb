Rails.application.routes.draw do
  devise_for :users
  root to: 'users/posts#index'

  namespace :users do
    resources :posts, except: :show, path: 'home' do
      resources :comments, except: :show
    end
    resources :friendships do
      put :confirm, :cancel, :decline, :unfriend
    end
    resources :groups
    resources :join_groups, only: [:create, :index, :update] do
      put :approve, :cancel, :decline, :leave, :remove
    end
  end
end
