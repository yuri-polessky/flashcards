require 'rails_helper'

describe 'Management cards' do

  context "registered user" do

    let!(:user) { create(:user) }
    let!(:deck) { create(:deck, user: user) }
    before(:each) do
      login(user.email, "pass")
    end
    
    it "can add card" do
      visit new_card_path
      fill_in "card_original_text", with: "way"
      fill_in "card_translated_text", with: "путь"
      select "English", from: "Колода"
      click_button "Добавить карточку"
      expect(page).to have_content "Успешно добавлена карточка"
    end

    it "can view his cards" do
      create(:card, translated_text: "путь", deck: deck)
      visit cards_path
      expect(page).to have_content "путь"
    end

    it "can't view another user's cards" do
      user2 = create(:user)
      deck2 = create(:deck, user: user2, name: "French")
      create(:card, translated_text: "путь", deck: deck2)

      visit cards_path
      expect(page).to_not have_content "путь"
    end
  end

  context "guest" do
    it "can't add card" do
      visit new_card_path
      expect(page).to have_content "Пожалуйста зарегистрируйтесь сначала."
    end

    it "can't view cards" do
      visit cards_path
      expect(page).to have_content "Пожалуйста зарегистрируйтесь сначала."
    end
  end
end