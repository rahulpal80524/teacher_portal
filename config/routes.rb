Rails.application.routes.draw do
  devise_for :teachers
  root to: 'students#index'
  resources :students, only: [:create, :update, :destroy, :show, :edit]
end
