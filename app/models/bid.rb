class Bid < ActiveRecord::Base
  belongs_to :auction
  belongs_to :user  

  validates :price, :auction, :user, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, fractionality: { multiplier: 0.01 }
end
