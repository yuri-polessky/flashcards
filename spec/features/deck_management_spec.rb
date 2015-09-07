require 'rails_helper'

describe 'Management decks' do
  
  context "registered user" do

    let!(:user) { create(:user) }
    before(:each) do
      login(user.email, "pass")
    end
    
    it "can add deck" do
      visit new_deck_path
      fill_in "deck_name", with: "English"
      click_button "Create Deck"
      expect(page).to have_content "Успешно добавлена колода"
    end

    it "can view his decks" do
      create(:deck, user: user)
      visit decks_path

      expect(page).to have_content "English"
    end

    it "can't view another user's decks" do
      user2 = create(:user)
      create(:deck, name: "French", user: user2)

      visit decks_path
      expect(page).to_not have_content "French"
    end

    it "highlight current deck" do
      deck = create(:deck, user: user)
            
      visit decks_path
      click_link 'Set current'

      expect(page).to have_css('tr.success')
      within(".success") do
        expect(page).to have_content "English"
      end
    end
  end

  context "guest" do
    it "can't add card" do
      visit new_deck_path
      expect(page).to have_content "Please login first"
    end

    it "can't view cards" do
      visit decks_path
      expect(page).to have_content "Please login first"
    end

  end

end