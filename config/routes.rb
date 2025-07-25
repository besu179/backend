Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # User authentication
  post "/login", to: "users#login"
  delete "/logout", to: "users#logout"

  # Users resource
  resources :users, only: [:create, :show, :update, :destroy]

  # Posts resource
  resources :posts do
    collection do
      get :my_posts
    end
  end

  # Comments resource
  resources :comments, only: [:index, :show, :create, :destroy]

  # Defines the root path route ("/")
  # root "posts#index"
end
