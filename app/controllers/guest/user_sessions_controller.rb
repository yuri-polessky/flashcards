class Guest::UserSessionsController < GuestController
  
  def new
    @user = User.new
  end
  
  def create
    if @user = login(params[:signin][:email], params[:signin][:password])
      redirect_back_or_to root_url, notice: t(:success_signin)
    else
      flash.now[:alert] = t(:failed_signin)
      render :new
    end
  end
end