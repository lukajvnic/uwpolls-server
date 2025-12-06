Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  get "/test/:name", to: "test#helloworld"

  post "/poll/createpoll", to: "poll#create_poll"
  post "/poll/votepoll", to: "poll#vote_poll"
  get "poll/search", to: "poll#search_polls"
  post "/poll/deletepoll", to: "poll#delete_poll"
  get "/poll/random", to: "poll#get_random_poll"
  get "/poll/recent", to: "poll#get_recent_polls"
  get "/poll/popular", to: "poll#get_popular_polls"
  get "/poll/:id/peek", to: "poll#peek_poll"

  get "/auth/health", to: "auth#health"
  post "/auth/login", to: "auth#email_login"
  post "/auth/signup", to: "auth#email_signup"
  post "/auth/logout", to: "auth#logout"
  get "/poll/trending", to: "poll#get_trending_polls"
  
end
