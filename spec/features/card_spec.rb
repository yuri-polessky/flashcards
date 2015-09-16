require 'rails_helper'

describe 'Review cards' do
  
  let!(:user) { create(:user) }
  let!(:deck) { create(:deck, user: user) }
  let!(:card) { create(:card, deck: deck) }

  before(:each) do
    login(user.email, "pass")
    visit root_path
  end
  
  it "show 'Right' with correct answer", js: true do
    fill_in :review_answer, with: card.original_text
    click_button "Проверить"

    expect(page).to have_content "Правильно"
  end

  it "show 'Right and typo' with mistyped answer", js: true do
    fill_in :review_answer, with: "wey"
    click_button "Проверить"

    expect(page).to have_content "Перевод для путь - way. Вы опечатались: wey"
  end

  it "show 'wrong' with incorrect answer", js: true do
    fill_in :review_answer, with: "***"
    click_button "Проверить"

    expect(page).to have_content "Неправильно"
  end

  it "show 'failed' with three incorrect answers in row", js: true do
    card.update(failed_review_count: 2)
    fill_in :review_answer, with: "***"
    click_button "Проверить"

    expect(page).to have_content "Три неправильных ответа подряд."
  end

  it "show cards from current deck" do
    new_deck = create(:deck, user: user)
    user.update(current_deck: new_deck)

    visit root_path
    
    expect(page).to_not have_content "Исходный текст"
  end
end