require 'rails_helper'

describe 'Review cards' do
  
  let!(:user) { create(:user) }
  let!(:deck) { create(:deck, user: user) }
  let!(:card) { create(:card, deck: deck) }

  before(:each) do
    card.review_date = Date.current
    card.save
    login(user.email, "pass")
    visit root_path
  end
  
  it "show 'Right' with correct answer" do
    fill_in :review_answer, with: card.original_text
    click_button "Проверить"

    expect(page).to have_content "Правильно"
  end

  it "show 'wrong' with incorrect answer" do
    fill_in :review_answer, with: "***"
    click_button "Проверить"

    expect(page).to have_content "Неправильно"
  end

  it "show cards from current deck" do
    current_deck = create(:deck, user: user, current: true)
    visit root_path
    
    expect(page).to_not have_content "Исходный текст"
  end

end