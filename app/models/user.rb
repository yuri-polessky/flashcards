class User < ActiveRecord::Base
  has_many :cards
  validates_presence_of :email, :password, presence: true
end
