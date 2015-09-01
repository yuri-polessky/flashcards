class Card < ActiveRecord::Base
  validates :original_text, presence: true
  validates :translated_text, presence: true
  validates :review_date, presence: true
  validate  :uniqueness_original_and_translated_text
  before_validation :set_review_date, on: :create

  private
    def uniqueness_original_and_translated_text
      if translated_text.downcase.strip == original_text.downcase.strip
        errors.add(:translated_text,"can't be same as original text")
      end
    end

    def set_review_date
      self.review_date = Date.current + 3.day
    end
end
