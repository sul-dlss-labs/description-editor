# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :descriptions, only: [:show] do
    resources :titles, only: [:index]
    get '/:field', to: 'fields#show'
  end

  post 'load', to: 'home#load'
  root to: 'home#index'
end
