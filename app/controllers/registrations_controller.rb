class RegistrationsController < ApplicationController
  skip_before_action :require_login
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(params[:user][:email],params[:user][:password])
      redirect_to root_url, notice: "Вы успешно зарегистрировались!"
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end