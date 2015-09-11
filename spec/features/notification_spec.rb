require 'rails_helper'

describe 'Notification' do
  it "send mail users with pending cards" do
    user = create(:user, email: "example@mail.com",screen_name: "john")
    deck = create(:deck, user: user)
    create(:card,deck: deck)
    create(:card,deck: deck)
    login(user.email, "pass")

    User.notify_pending_cards

    expect(ActionMailer::Base.deliveries.count).to eql 1
    expect(ActionMailer::Base.deliveries.last.to).to include user.email
    expect(ActionMailer::Base.deliveries.last.body).to match /2 cards/
  end

end