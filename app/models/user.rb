class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end
  has_many :decks
  belongs_to :current_deck, class_name: "Deck", foreign_key: "deck_id"
  has_many :cards, through: :decks
  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications
  
  validates :password, length: { minimum: 3 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true
  validates :email, :password, presence: true

  def cards_from_current_deck_or_all_cards
    current_deck ? current_deck.cards : cards
  end
end
