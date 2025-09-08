Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'http://localhost:5173'  # Change so that its the frontend port
      resource '*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        credentials: true
    end
  end
  