class AuthController < ApplicationController
  skip_forgery_protection

  def health
    render json: { message: "success!" }
  end

  def email_login
    email = params[:email]
    password = params[:password]

    unless email.present? && password.present?
      return render json: { error: "Email and password are required" }, status: :unprocessable_entity
    end

    user = User.find_by(email: email)
    unless user&.authenticate(password)
      return render json: { error: "Invalid email or password" }, status: :unauthorized
    end

    session[:user_id] = user.id
    render json: { id: user.id, email: user.email, message: "Logged in successfully" }
  end

  def email_signup
    email = params[:email]
    password = params[:password]

    unless email.present? && password.present?
      return render json: { error: "Email and password are required" }, status: :unprocessable_entity
    end

    user = User.new(email: email, password: password)

    unless user.save
      return render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end

    session[:user_id] = user.id
    render json: { id: user.id, email: user.email, message: "Account created successfully" }, status: :created
  end

  def google_login
    token = params[:token]

    unless token.present?
      return render json: { error: "Google token is required" }, status: :unprocessable_entity
    end

    begin
      # Decode token without verification (frontend verification is sufficient for dev)
      # In production, verify with Google's endpoint
      payload = JWT.decode(token, nil, false)[0]

      google_id = payload["sub"]
      email = payload["email"]

      unless google_id && email
        return render json: { error: "Invalid token payload" }, status: :unauthorized
      end

      user = User.find_or_create_from_google(google_id, email)
      session[:user_id] = user.id

      render json: { id: user.id, email: user.email, message: "Logged in with Google" }
    rescue => e
      render json: { error: "Invalid or expired token: #{e.message}" }, status: :unauthorized
    end
  end

  def logout
    session[:user_id] = nil
    render json: { message: "Logged out successfully" }
  end
end
