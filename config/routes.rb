Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
  root "top#index"
  
  namespace :admin do
    resources :books, only: [:index, :new, :create] do
      collection do
        post 'search'
      end
    end
    resources :users, only: [:index]
    resources :requests, only: [:index, :update]
  end
  resources :books
  resources :requests, only: [:new, :create] do
    collection do
      get 'search'
      post 'search'
    end
  end

  
  resources :reservations, only: [:index, :show, :create, :destroy]
  resources :lendings, only: [:index, :show, :create, :update]
  
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
