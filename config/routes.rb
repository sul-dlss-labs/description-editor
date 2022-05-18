# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :descriptions, only: [:show] do
    resources :titles, only: %i[index edit update new create] do
      member do
        post 'move'
      end
    end
    get '/:field', to: 'fields#show'
  end

  post 'load', to: 'home#load'
  root to: 'home#index'
end
