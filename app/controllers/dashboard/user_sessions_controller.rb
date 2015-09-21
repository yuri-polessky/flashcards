class Dashboard::UserSessionsController < DashboardController
  def destroy
    logout
    redirect_to root_url, notice: t(:success_logout)
  end
end