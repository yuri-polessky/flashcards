require 'rails_helper'

describe Card do

  let!(:user) { create(:user) }

  it "has correct review_date after creation" do
    card = user.cards.create(original_text: "way", translated_text: "путь")
    expect(card.review_date).to eq Date.current
  end

  it "has correct review_count after creation" do
    card = user.cards.create(original_text: "way", translated_text: "путь")
    expect(card.review_count).to eq 0
  end

  describe "validate original_text and translated_text" do
    
    context "with same word" do
      it "is invalid" do
        card = Card.new(original_text: "way", translated_text: "way")
        card.valid?
        expect(card.errors[:translated_text]).to include("Не может быть одинаковым с исходным текстом")
      end
    end

    context "with same word in different letter cases " do
      it "is invalid" do
        card = Card.new(original_text: "way", translated_text: "WAY")
        card.valid?
        expect(card.errors[:translated_text]).to include("Не может быть одинаковым с исходным текстом")
      end
    end

    context "with same word with leading and trailing space" do
      it "is invalid" do
        card = Card.new(original_text: " way", translated_text: "way ")
        card.valid?
        expect(card.errors[:translated_text]).to include("Не может быть одинаковым с исходным текстом")
      end
    end
  end
end