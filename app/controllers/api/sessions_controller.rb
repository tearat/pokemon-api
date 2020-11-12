class Api::SessionsController < ApplicationController
  before_action :sign_in_params, only: :create
  before_action :load_user, only: :create

  # sign in
  def create
    if @user.valid_password?(sign_in_params[:password])
      sign_in "user", @user
      render json: {
        message: "Signed In Successfully",
        is_success: true,
        data: {user: {
            id: @user.id,
            username: @user.username,
            email: @user.email,
            authentication_token: @user.authentication_token,
        }}
      }, status: :ok
    else
      render json: {
        message: "Signed In Failed - Unauthorized",
        is_success: false,
        data: {}
      }, status: :unauthorized
    end
  end

  def destroy
    if current_user
      sign_out @user
      render json: {
        message: "Signed Out Successfully",
        is_success: true,
        data: {}
      }, status: :ok
    else
      render json: {
        message: "Signed Out Failed - Unauthorized",
        is_success: false,
        data: {}
      }, status: :unauthorized
    end
  end

  private

  def sign_in_params
    params.require(:sign_in).permit :email, :password
  end

  def load_user
    @user = User.find_for_database_authentication(email: sign_in_params[:email])
    if @user
      return @user
    else
      render json: {
        message: "Cannot get User",
        is_success: false,
        data: {}
      }, status: :failure
    end
  end
end
