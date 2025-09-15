require 'httparty'

class AuthenticationController < ApplicationController
  before_action :authorize_request, except: [:login, :google_login]

  # POST /auth/login
  def login
    begin
      @user = Account.find_by_email(params[:data][:email])
      
      if @user.nil?
        render json: { error: {email: 'Email not found'} }, status: :not_found
        return
      end
  
      if @user.authenticate(params[:data][:password])
        token = JsonWebToken.encode(user_id: @user.id)
        time = (Time.now + 24.hours).to_i

        render json: { token: token, exp: time }, status: :ok
      else
        render json: { error: {password: 'Please provide a valid password'} }, status: :unauthorized
      end
    rescue StandardError => e
      render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
    end
  end

  def google_login
    token = params[:token]
    google_response = HTTParty.get("https://oauth2.googleapis.com/tokeninfo?id_token=#{token}")

    if google_response.success?
      user_data = JSON.parse(google_response.body)
      
      email = user_data["email"]
      first_name = user_data["given_name"]
      last_name = user_data["family_name"]
      
      user = Account.find_or_create_by(email: email) do |u|
        u.first_name = first_name
        u.last_name  = last_name
        u.password = SecureRandom.hex(10)  
      end

      jwt_token = JsonWebToken.encode(user_id: user.id) 
      time = Time.now + 24.hours.to_i
      render json: { token: jwt_token, exp:  time.strftime("%m-%d-%Y %H:%M")}, status: :ok
    else
      render json: { error: "Invalid token" }, status: :unauthorized
    end
  end
  

  private

  def login_params
    params.require(:data).permit(:email, :password)
  end
end
