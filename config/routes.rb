Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :issues, only: [:index, :create]
  resources :filtered_tags, only: :create
  # resources :tags, only: :index

  root to: 'issues#index'
end
