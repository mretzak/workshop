Rails.application.routes.draw do
  # Mount GraphiQL endpoint for development
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  post "/graphql", to: "graphql#execute"

  # Workshop routes demonstrating N+1 problems and solutions
  namespace :api do
    namespace :v1 do
      # Posts endpoints for N+1 demonstration
      get 'posts/n_plus_one', to: 'posts#index_with_n_plus_one'
      get 'posts/optimized', to: 'posts#index_optimized'
      get 'posts/includes', to: 'posts#index_with_includes'
      get 'posts/preload', to: 'posts#index_with_preload'
      get 'posts/eager_load', to: 'posts#index_with_eager_load'

      # Users endpoints for N+1 demonstration
      get 'users/n_plus_one', to: 'users#index_with_n_plus_one'
      get 'users/optimized', to: 'users#index_optimized'
    end
  end

  # Simpler routes for workshop demonstrations
  get 'posts/n_plus_one', to: 'posts#index_with_n_plus_one'
  get 'posts/optimized', to: 'posts#index_optimized'
  get 'posts/includes', to: 'posts#index_with_includes'
  get 'posts/preload', to: 'posts#index_with_preload'
  get 'posts/eager_load', to: 'posts#index_with_eager_load'

  get 'users/n_plus_one', to: 'users#index_with_n_plus_one'
  get 'users/optimized', to: 'users#index_optimized'

  # Route for workshop challenges page
  get 'challenges', to: 'challenges#index', as: :workshop_challenges

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
