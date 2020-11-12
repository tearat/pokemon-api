class Api::RegistrationsController < ApplicationController
  before_action :ensure_params_exist, only: :create
  skip_before_action :verify_authenticity_token, :only => :create, raise: false

  # sign up
  def create
    user = User.new user_params
    if user.save
      render json: {
        message: "Sign Up Successfully",
        is_success: true,
        data: { user: user }
      }, status: :ok
    else
      render json: {
        message: "Sign Up Failded",
        is_success: false,
        data: {}
      }, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end

  def ensure_params_exist
    return if params[:user].present?
    render json: {
        message: "Missing Params",
        is_success: false,
        data: {}
      }, status: :bad_request
  end
end
