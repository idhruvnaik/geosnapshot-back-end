Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :serving_table do
    match "list", via: [:get, :options]
  end

  namespace :food do
    namespace :category do
      match "list", via: [:get, :options]
    end

    namespace :item do
      match "list", via: [:get, :options]
    end
  end

  namespace :order do
    match "place", via: [:post, :options]
    match "list", via: [:get, :options]
    match "update_order_item", via: [:post, :options]
    match "update_order", via: [:post, :options]
    match "delete_order_item", via: [:delete, :options]
  end

  namespace :kitchen do
    match "list", via: [:get, :options]
    match "update_order", via: [:post, :options]
  end
end
