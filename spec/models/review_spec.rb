require 'rails_helper'

describe Review do
  describe "checks translation" do
    
    let(:card) { create(:card) }

    context "with correct answer" do

      let(:review) { Review.new(card.id, "way") }

      it "returns true" do
        expect(review.check_translation).to be_truthy
      end
      
      it "increase review_count by one" do
        expect {
          review.check_translation
        }.to change { card.reload.review_count }.by(1)
      end

      it "update interval" do
        review.check_translation
        expect(card.reload.interval).to eql 1
      end

      it "increase review date " do
        review.check_translation
        expect(card.reload.review_date).to eql Date.current + 1.day
      end

      it "update E-Factor" do
        review.check_translation
        expect(card.reload.efactor).to eql 2.6
      end
    end

    context "with correct answer in different letter case" do
      it "returns true" do
        review = Review.new(card.id, "WaY")
        expect(review.check_translation).to be_truthy
      end
    end

    context "with correct answer with trailing space" do
      it "returns true" do
        review = Review.new(card.id, "way ")
        expect(review.check_translation).to be_truthy
      end
    end

    context "with correct answer with typo" do
      it "returns true" do
        review = Review.new(card.id, "wey ")
        expect(review.check_translation).to be_truthy
      end
    end

    context "with incorrect answer" do
      let(:review) { Review.new(card.id, "wei") }
      
      it "returns false" do 
        expect(review.check_translation).to be_falsey
      end

      it "doesn't increase review_count" do
        expect {
          review.check_translation
        }.to_not change(card.reload, :review_count)
      end

      it "doesn't change interval" do
        expect {
          review.check_translation
        }.to_not change(card.reload, :interval)
      end

      it "doesn't change review date " do
        expect {
          review.check_translation
        }.to_not change(card.reload, :review_date)
      end

      it "doesn't change E-Factor" do
        expect {
          review.check_translation
        }.to_not change(card.reload, :efactor)
      end

      it "increase failed_review_count by one" do
        expect {
          review.check_translation
        }.to change { card.reload.failed_review_count }.by(1)
      end
    end

    context "three incorrect answers in row" do
      let(:review) { Review.new(card.id, "wei") }
      before do
        card.update(failed_review_count: 2)
      end

      it "reset failed_review_count after three incorrect answers" do
        review.check_translation
        
        expect(card.reload.failed_review_count).to eq 0
      end

      it "reset date_review_count after three incorrect answers" do
        review.check_translation
        
        expect(card.reload.review_date).to eq Date.current + 1.days
      end

      it "left same E-Factor after three incorrect answers" do
        card.update(efactor: 3.0)
        review.check_translation
        
        expect(card.reload.efactor).to eq 3.0
      end

      it "reset review_count after three incorrect answers" do
        review.check_translation
        
        expect(card.reload.review_count).to eq 1
      end
    end
  end

  describe "assessment quality" do
    let(:card) { create(:card) }

    it "fast answer without typos get maximum quality" do
      review = Review.new(card.id, "way", 3)
      
      expect(review.quality).to eql 5
    end

    it "each 30 sec decrease answer quality by 1" do
      review = Review.new(card.id, "way", 31)
      
      expect(review.quality).to eql 4
    end

    it "very slow answer decrease answer quality max by 2" do
      review = Review.new(card.id, "way", 140)
      
      expect(review.quality).to eql 3
    end

    it "typo decrease answer quality by 1" do
      review = Review.new(card.id, "wey", 3)
      
      expect(review.quality).to eql 4
    end

    it "each failed answer decrease next answer quality by 1" do
      card.update(failed_review_count: 1)
      review = Review.new(card.id, "way", 3)
      
      expect(review.quality).to eql 4
    end
  end
end