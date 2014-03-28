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

  before_create { |auction| auction.price = auction.start_price }

  def self.finished_soon
    # TODO: use PostgreSQL
    Auction.all.select { |a| (a.time_left <= 5.seconds) && (a.time_left > 1.second) }
  end

  def started?
    start_time < Time.now
  end

  def finished?
    time_left < 0
  end

  def active?
    started? && !finished?
  end

  def time_left
    finish_time - Time.now
  end

  def start_in
    start_time - Time.now
  end

  def finish_time
    start_time + duration.seconds
  end

  def last_user
    bids.sorted.last.user if bids.any?
  end

  def increase_price_and_time
    self.price += self.bid_price_step
    self.duration += self.bid_time_step
    self.save!
  end

  def publish_updates
    PrivatePub.publish_to '/auctions/update', auction_id: self.id, time_left: self.status_desc, price: self.price
  end

  def status_desc
    status_desc_with do |delta|
      Auction.timespan_to_s(delta)
    end
  end

  def self.timespan_to_s(seconds)
    hours = seconds / 3600
    minutes = (seconds - hours*3600) / 60
    seconds = seconds % 60
    '%02d:%02d:%02d' % [hours, minutes, seconds]
  end

  private

  def status_desc_with(&time_span_to_s)
    if !self.started?
      I18n.t('auctions.index.start_in', delta: time_span_to_s.call(self.start_in))
    elsif self.finished?
      I18n.t('auctions.index.finished_in', delta: time_span_to_s.call(-self.time_left))
    else
      I18n.t('auctions.index.finish_in', delta: time_span_to_s.call(self.time_left))
    end
  end
end