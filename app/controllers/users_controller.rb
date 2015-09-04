class UsersController < ApplicationController
  skip_before_filter :require_login, :only => [:new,:create]
  before_action :set_user, only: [:edit,:update]
  
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

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to root_url
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
