require 'rails_helper'

describe Card do

  let!(:user) { create(:user) }

  it "has correct review_date after creation" do
    Timecop.freeze
    card = user.cards.create(original_text: "way", translated_text: "путь")
    expect(card.review_date).to eq Time.now
    Timecop.return
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
        expect(card.errors[:translated_text]).to include("can't be same as original text")
      end
    end

    context "with same word in different letter cases " do
      it "is invalid" do
        card = Card.new(original_text: "way", translated_text: "WAY")
        card.valid?
        expect(card.errors[:translated_text]).to include("can't be same as original text")
      end
    end

    context "with same word with leading and trailing space" do
      it "is invalid" do
        card = Card.new(original_text: " way", translated_text: "way ")
        card.valid?
        expect(card.errors[:translated_text]).to include("can't be same as original text")
      end
    end
  end
end