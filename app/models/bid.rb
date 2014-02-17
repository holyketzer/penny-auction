class Bid < ActiveRecord::Base
  belongs_to :auction
  belongs_to :user  

  validates :auction, :user, presence: true
  validate :auction_active?, message: :auction_active
  validate :last_user_different?

  scope :sorted, -> { order(:created_at) }

  after_create :update_auction

  private

  def auction_active?
    if auction && !auction.active?      
      if auction.finished?
        errors.add(:auction, :finished)
      else
        errors.add(:auction, :not_started)
      end
    end
  end

  def last_user_different?
    if auction && user
      errors.add(:user, :same_user_twice) if auction.last_user == user
    end
  end

  def update_auction
    auction.increase_price_and_time
  end
end
