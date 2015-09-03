require 'rails_helper'

describe Review do
  describe "checks translation" do
    
    before :each do 
      @card = Card.create(original_text: "way", translated_text: "путь")
    end

    context "with correct answer" do
      it "returns true" do 
        review = Review.new(card_id: @card.id, answer: "way")
        expect(review.check_translation).to be_truthy
      end
    end

    context "with correct answer in different letter case" do
      it "returns true" do 
        review = Review.new(card_id: @card.id, answer: "WaY")
        expect(review.check_translation).to be_truthy
      end
    end

    context "with correct answer with trailing space" do
      it "returns true" do 
        review = Review.new(card_id: @card.id, answer: "way ")
        expect(review.check_translation).to be_truthy
      end
    end    

    context "with incorrect answer" do
      it "returns false" do 
        review = Review.new(card_id: @card.id, answer: "wey")
        expect(review.check_translation).to be_falsey
      end
    end

  end
end