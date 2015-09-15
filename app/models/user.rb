class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end
  has_many :decks
  belongs_to :current_deck, class_name: "Deck"
  has_many :cards, through: :decks
  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications
  
  with_options if: -> { new_record? || changes["password"] } do
    validates :password, length: { minimum: 3 } 
    validates :password, confirmation: true
    validates :password_confirmation, presence: true
  end
  validates :email, presence: true, if: -> { new_record? || changes["email"] }

  def cards_for_review
    current_deck ? current_deck.cards.for_review : cards.for_review
  end

  def self.notify_pending_cards
    joins(:cards).where("cards.review_date <= ?", Date.current).group("users.id").
      select("users.*, count(cards.id) as count_card").each do |user|
        NotificationMailer.pending_cards(user).deliver_now
    end
  end
end
