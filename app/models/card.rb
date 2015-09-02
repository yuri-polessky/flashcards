class Card < ActiveRecord::Base
  validates_presence_of :original_text, :translated_text, :review_date, presence: true
  validate  :uniqueness_original_and_translated_text
  validate :correctness_answer, on: :update, if: :answer_original_text
  before_validation :set_review_date, on: :create
  before_save :set_review_date, on: :update, if: :answer_original_text
  attr_accessor :answer_original_text

  scope :for_review, -> { where("review_date <= ?", Date.current) }

  def correctness_answer
    unless answer_original_text.strip.mb_chars.downcase  == original_text.strip.mb_chars.downcase
      errors.add(:answer_original_text,"answer is wrong")
    end
  end

  private
    def uniqueness_original_and_translated_text
      if translated_text.strip.mb_chars.downcase  == original_text.strip.mb_chars.downcase
        errors.add(:translated_text,"can't be same as original text")
      end
    end

    def set_review_date
      self.review_date = Date.current + 3.day
    end
end
