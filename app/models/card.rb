class Card < ActiveRecord::Base
  belongs_to :deck
  has_attached_file :picture, styles: { medium: '360x360' },
    default_url: "/images/:style/missing.png"
  validates_attachment :picture, 
    content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }
  validates :original_text, :translated_text, :review_date, presence: true
  validates :deck, presence: true, unless: :new_deck_name?
  validate  :uniqueness_original_and_translated_text
  before_validation :set_review_date, on: :create
  before_save :create_deck_from_new_deck_name
  attr_accessor :new_deck_name, :user_id

  scope :for_review, -> { where("review_date <= ?", Date.current) }

  def set_review_date
    self.review_date = Date.current + 3.day
  end

  def create_deck_from_new_deck_name
    unless new_deck_name.blank?
      new_deck = Deck.find_or_initialize_by(name: new_deck_name)
      new_deck.update(name: new_deck_name, user_id: user_id)
      self.deck = new_deck
    end
  end


  private
  
  def uniqueness_original_and_translated_text
    if original_text && translated_text
      if translated_text.strip.mb_chars.downcase == original_text.strip.mb_chars.downcase
        errors.add(:translated_text,"can't be same as original text")
      end
    end
  end

  def new_deck_name?
    !new_deck_name.blank?
  end

end
