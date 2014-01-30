class Auction < ActiveRecord::Base
  belongs_to :product
  belongs_to :image

  validates :product_id, :min_price, :start_price, :duration, :bid_time_step, :bid_price_step, presence: true  
  validates :duration, :bid_time_step, numericality: { only_integer: true }
  validates :min_price, :start_price, :bid_price_step, numericality: { greater_than_or_equal_to: 0.01 }
  validates :min_price, :start_price, :bid_price_step, fractionality: { multiplier: 0.01 }
end