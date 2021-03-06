class Guest::RegistrationsController < GuestController
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(params[:user][:email],params[:user][:password])
      redirect_to root_url, notice: t(:success_signup)
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,:locale)
  end
end