require 'rails_helper'

describe SuperMemo do
  
  describe "E-Factor" do
      
    it "with quality 5 returns E-Factor increasing to 0.1" do
      sm = build(:super_memo, quality: 5)
      diff = sm.get_new_params[:efactor] - sm.efactor
      expect(diff).to be_within(0.001).of(0.1)
    end

    it "with quality 4 returns same E-Factor" do
      sm = build(:super_memo, quality: 4)
      diff = sm.get_new_params[:efactor] - sm.efactor
      expect(diff).to eql 0.0
    end

    it "with quality 3 returns E-Factor reducing to 0.14" do
      sm = build(:super_memo, quality: 3)
      diff = sm.get_new_params[:efactor] - sm.efactor
      expect(diff).to be_within(0.001).of(-0.14)
    end

    it "with quality 2 and below returns same E-Factor" do
      sm = build(:super_memo, quality: 2)
      diff = sm.get_new_params[:efactor] - sm.efactor
      expect(diff).to eql 0.0
    end

    it "cannot reducing E-Factor below 1.3" do
      sm = build(:super_memo, efactor: 1.3, quality: 3)
      expect(sm.get_new_params[:efactor]).to eql 1.3
    end
  end

  describe "Interval" do

    it "with quality 2 and below returns 1 day" do
      sm = build(:super_memo, quality: 2, interval: 10, review_count: 4)
      expect(sm.get_new_params[:interval]).to eql 1
    end

    it "with first review returns 1 day" do
      sm = build(:super_memo, review_count: 0)
      expect(sm.get_new_params[:interval]).to eql 1
    end

    it "with second review returns 6 day" do
      sm = build(:super_memo, review_count: 1)
      expect(sm.get_new_params[:interval]).to eql 6
    end

    it "with third and next review returns E-Factor * previous interval" do
      sm = build(:super_memo, review_count: 3, efactor: 2.3, interval: 6)
      expect(sm.get_new_params[:interval]).to eql 14
    end
  end

  describe "Review count" do
    it "with quality 2 and below reset review count" do
      sm = build(:super_memo, quality: 2, interval: 10, review_count: 4)
      expect(sm.get_new_params[:review_count]).to eql 1
    end

    it "with quality 3 and above increase review count by 1" do
      sm = build(:super_memo, quality: 4, interval: 10, review_count: 4)
      expect(sm.get_new_params[:review_count]).to eql 5
    end
  end
end
