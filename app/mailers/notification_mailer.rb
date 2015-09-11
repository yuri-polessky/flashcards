class NotificationMailer < ActionMailer::Base
  default from: "neoander000@gmail.com"

  def pending_cards(user)
    @user = user
    @url = root_url
    mail(to: @user.email, subject: "Карточки для ревью")
  end
end