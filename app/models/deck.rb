class Deck < ActiveRecord::Base
  has_many :cards, dependent: :delete_all
  belongs_to :user
  
  validates :name, :user, presence: true

end
