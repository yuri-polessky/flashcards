class OauthsController < ApplicationController
  skip_before_action :require_login

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if @user = login_from(provider)
      redirect_to root_path, notice: t(:login_provider, provider: provider.titleize)
    else
      begin
        @user = create_from(provider)
        @user.update(locale: session[:locale])

        reset_session
        auto_login(@user)
        redirect_to root_path, notice: t(:login_provider, provider: provider.titleize)
      rescue
        redirect_to root_path, alert: t(:failed_login_provider, provider: provider.titleize)
      end
    end
  end

  private
  def auth_params
    params.permit(:code, :provider)
  end

end