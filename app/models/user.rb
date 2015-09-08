class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end
  has_many :decks
  belongs_to :current_deck, class_name: "Deck", foreign_key: "deck_id"
  has_many :cards, through: :decks
  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications
  
  with_options if: -> { new_record? || changes["password"] } do
    validates :password, length: { minimum: 3 } 
    validates :password, confirmation: true
    validates :password_confirmation, presence: true
  end
  validates :email, presence: true

  def cards_for_review
    current_deck ? current_deck.cards.for_review : cards.for_review
  end
end
