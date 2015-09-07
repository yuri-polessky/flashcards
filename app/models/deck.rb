class Deck < ActiveRecord::Base
  has_many :cards, dependent: :delete_all
  belongs_to :user
  
  validates :name, :user, presence: true
  
  scope :current, -> { where(current: true) }
  
  def self.unset_current_deck
    current.update(current: false)
  end

end
