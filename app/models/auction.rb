class Auction < ActiveRecord::Base
  belongs_to :product
  belongs_to :image
  has_many :bids

  validates :product, :image, :min_price, :start_price, :start_time, :duration, :bid_time_step, :bid_price_step, presence: true  
  validates :duration, :bid_time_step, numericality: { only_integer: true }
  validates :min_price, :start_price, :bid_price_step, numericality: { greater_than_or_equal_to: 0.01 }
  validates :min_price, :start_price, :bid_price_step, fractionality: { multiplier: 0.01 }

  after_initialize do
    self.start_time = Time.now.round_by(15.minutes) if self.new_record? && self.start_time.nil?
  end

  def started
    start_time < Time.now
  end

  def finished
    rest_of_time < 0    
  end

  def active
    started && !finished
  end

  def rest_of_time    
    (start_time + duration.seconds - Time.now).to_i
  end

  def start_in
    (start_time - Time.now).to_i
  end

  def finish_time
    start_time + duration.seconds
  end
end