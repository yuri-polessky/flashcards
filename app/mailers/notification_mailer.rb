class NotificationMailer < ActionMailer::Base

  def pending_cards(user)
    @user = user
    mail(to: @user.email, subject: "Карточки для ревью")
  end
end