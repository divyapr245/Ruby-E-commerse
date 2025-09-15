class AccountsController < ApplicationController
  before_action :authorize_request, only: [:show_current_user_details]
  def create 
    account = Account.new(user_params)
    if account.save
      render json: {message: "Account Created Successfully", account: account}, status: :created 
    else 
      render json: {error: account.errors.to_hash(true)}, status: :unprocessable_entity
    end
  end

  def show_current_user_details 
    if @current_user.present?
      render json: {current_user: @current_user}, status: :ok
    else 
      render json: {error: "User need to login first"}
    end
  end


  def get_countries 
    countries = CS.countries
    if countries 
      render json: {countries: countries}
    else 
      render json: {error: "No countries found"}
    end
  end

  def get_state 
    states = CS.states(params[:country_code])
    if states 
      render json: {states: states}
    else 
      render json: {error: "No cities found"}
    end
  end

   def get_cities 
    cities = CS.cities(params[:city_code])
    if cities 
      render json: {cities: cities}
    else 
      render json: {error: "No state found"}
    end
  end

  private 
  def user_params
    params.require(:account).permit(:first_name, :last_name, :phone_no, :email, :password, :password_confirmation, :country, :state, :city)
  end
end
