Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
  root "top#index"
  namespace :admin do
    resources :books, only: [:index]
  end
  
  resources :books
  resources :reservations
  resources :lendings, only: [:index, :show, :update]
end
