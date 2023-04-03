Rails.application.routes.draw do


  get 'books/new'
  get 'books/index'
  get 'books/show'
  get 'books/edit'
  get 'books/destory'
  devise_for :users
  resources :users, only: [:index, :show, :edit, :update]
  resources :books, only: [:new, :create, :index, :show, :edit, :destroy]

  root to: "homes#top"
  get 'homes/about' => "homes#about", as: 'about'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

