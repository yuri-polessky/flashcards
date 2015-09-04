class UserSessionsController < ApplicationController
  skip_before_filter :require_login, :except => [:destroy]
  
  def new
    @user = User.new
  end
  
  def create
    if @user = login(params[:signin][:email],params[:signin][:password])
      redirect_back_or_to root_url, notice: 'Успешный вход'
    else
      flash.now[:alert] = "Вход не удался."
      render :new
    end
  end
  
  def destroy
    logout
    redirect_to root_url, notice: 'Успешный выход!'
  end

end