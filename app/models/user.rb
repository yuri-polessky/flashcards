class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end
  has_many :decks
  belongs_to :current_deck, class_name: "Deck", foreign_key: "deck_id"
  has_many :cards, through: :decks
  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications
  
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes["password"] }
  validates :password, confirmation: true, if: -> { new_record? || changes["password"] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes["password"] }
  validates :email, presence: true

  def cards_for_review
    current_deck ? current_deck.cards.for_review : cards.for_review
  end
end
