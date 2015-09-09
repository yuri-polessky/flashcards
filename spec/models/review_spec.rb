require 'rails_helper'

describe Review do
  describe "checks translation" do
    
    let(:card) { create(:card) }

    context "with correct answer" do
      it "returns true" do
        review = Review.new(card_id: card.id, answer: "way")
        expect(review.check_translation).to be_truthy
      end
      
      it "increase review_count by one" do
        review = Review.new(card_id: card.id, answer: "way")
        expect {
          review.check_translation
        }.to change { card.reload.review_count }.by(1)
      end
    end

    context "with correct answer in different letter case" do
      it "returns true" do
        review = Review.new(card_id: card.id, answer: "WaY")
        expect(review.check_translation).to be_truthy
      end
    end

    context "with correct answer with trailing space" do
      it "returns true" do
        review = Review.new(card_id: card.id, answer: "way ")
        expect(review.check_translation).to be_truthy
      end
    end

    context "with incorrect answer" do
      it "returns false" do 
        review = Review.new(card_id: card.id, answer: "wey")
        expect(review.check_translation).to be_falsey
      end

      it "increase failed_review_count by one" do
        review = Review.new(card_id: card.id, answer: "wey")
        expect {
          review.check_translation
        }.to change { card.reload.failed_review_count }.by(1)
      end

      it "reset failed_review_count after three incorrect answers" do
        card.update(failed_review_count: 2)
        review = Review.new(card_id: card.id, answer: "wey")
        review.check_translation
        expect(card.reload.failed_review_count).to eq 0
      end

      it "reset date_review_count after three incorrect answers" do
        card.update(failed_review_count: 2)
        review = Review.new(card_id: card.id, answer: "wey")
        Timecop.freeze
        review.check_translation
        Timecop.freeze(Time.current + 12.hours)
        expect(card.reload.review_date.to_i).to eq Time.current.to_i
        Timecop.return
      end
    end
  end

  describe "increase review date" do

    let(:card) { create(:card) }
    after(:each) { Timecop.return }
    before(:each) { Timecop.freeze }

    it "increase review to 12 hours after first review" do
      new_review_date = get_new_review_date(12.hours)
      expect(new_review_date).to eq Time.current
    end

    it "increase review to 3 days after second review" do
      card.update(review_count: 1)
      new_review_date = get_new_review_date(3.day)

      expect(new_review_date).to eq Time.current
    end
    it "increase review to one week after third review" do
      card.update(review_count: 2)
      new_review_date = get_new_review_date(1.week)

      expect(new_review_date).to eq Time.current
    end
    it "increase review to two weeks after fourth review" do
      card.update(review_count: 3)
      new_review_date = get_new_review_date(2.week)

      expect(new_review_date).to eq Time.current
    end
    it "increase review to one month hours after fifth review" do
      card.update(review_count: 4)
      new_review_date = get_new_review_date(1.month)

      expect(new_review_date).to eq Time.current
    end
    it "increase review to one month hours after sixth review" do
      card.update(review_count: 5)
      new_review_date = get_new_review_date(1.month)

      expect(new_review_date).to eq Time.current
    end
  end
end