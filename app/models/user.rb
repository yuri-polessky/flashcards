class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end
  has_many :decks
  has_many :cards, through: :decks
  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications
  
  validates :password, length: { minimum: 3 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true
  validates :email, :password, presence: true
end
