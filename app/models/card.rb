class Card < ActiveRecord::Base
  validates_presence_of :original_text, :translated_text, :review_date, presence: true
  validate  :uniqueness_original_and_translated_text
  before_validation :set_review_date, on: :create

  scope :for_review, -> { where("review_date <= ?", Date.current) }

  def set_review_date
    self.review_date = Date.current + 3.day
  end
  
  private
    def uniqueness_original_and_translated_text
      if original_text && translated_text
        if translated_text.strip.mb_chars.downcase  == original_text.strip.mb_chars.downcase
          errors.add(:translated_text,"can't be same as original text")
        end
      end
    end

end
