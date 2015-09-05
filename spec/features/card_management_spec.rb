require 'rails_helper'

describe 'Management cards' do
  
  context "registered user" do

    let!(:user) { create(:user) }
    before(:each) do
      login(user.email, "pass")
    end
    
    it "can add card" do
      visit new_card_path
      fill_in "card_original_text", with: "way"
      fill_in "card_translated_text", with: "путь"
      click_button "Create Card"
      expect(page).to have_content "Успешно добавлена карточка"
    end

    it "can view his cards" do
      create(:card, translated_text: "путь", user: user)
      visit cards_path
      expect(page).to have_content "путь"
    end

    it "can't view another user's cards" do
      user2 = create(:user)
      create(:card, translated_text: "путь", user: user2)

      visit cards_path
      expect(page).to_not have_content "путь"
    end
  end

  context "guest" do
    it "can't add card" do
      visit new_card_path
      expect(page).to have_content "Please login first"
    end

    it "can't view cards" do
      visit cards_path
      expect(page).to have_content "Please login first"
    end

  end

end