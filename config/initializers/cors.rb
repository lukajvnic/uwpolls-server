Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "localhost:5000", "localhost:5173", "localhost:3000", "localhost:5431",
            "127.0.0.1:5000", "127.0.0.1:5173", "127.0.0.1:3000", "127.0.0.1:5431",
            "https://unmutative-countercurrently-leopoldo.ngrok-free.dev",
            "https://uwpolls-client.vercel.app",
            "uwpolls-client-j74yipxp3-lukas-projects-e2762843.vercel.app"
    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end
  