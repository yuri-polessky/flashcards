class ProfileController < ApplicationController
  skip_before_action :require_login

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to root_url
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end