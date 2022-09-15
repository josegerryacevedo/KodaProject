Rails.application.routes.draw do
  devise_for :users
  root to: 'users/home#index'
end
