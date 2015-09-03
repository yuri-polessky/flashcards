require 'rails_helper'

describe Card do

  it "has correct review_date after creation" do
    card = Card.create(original_text: "way", translated_text: "путь")
    expect(card.review_date).to eq Date.current + 3.day
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