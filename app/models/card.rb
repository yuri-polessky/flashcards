class Card < ActiveRecord::Base
  belongs_to :deck
  has_attached_file :picture, styles: { medium: '360x360' },
    default_url: "/images/:style/missing.png"
  validates_attachment :picture, 
    content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }
  validates :original_text, :translated_text, :review_date, presence: true
  validates :deck_id, presence: true
  validate  :uniqueness_original_and_translated_text
  before_validation :set_review_date, on: :create

  scope :for_review, -> { where("review_date <= ?", Date.current) }

  def set_review_date
    self.review_date = Date.current
  end

  private
  
  def uniqueness_original_and_translated_text
    if original_text && translated_text
      if translated_text.strip.mb_chars.downcase == original_text.strip.mb_chars.downcase
        errors.add(:translated_text, :same_as_original_text)
      end
    end
  end

end
