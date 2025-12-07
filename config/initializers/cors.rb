Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "localhost:5000", "localhost:5173", "localhost:3000",
            "127.0.0.1:5000", "127.0.0.1:5173", "127.0.0.1:3000",
            "https://unmutative-countercurrently-leopoldo.ngrok-free.dev"
    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end
  