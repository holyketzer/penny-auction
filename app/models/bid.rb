class Bid < ActiveRecord::Base
  belongs_to :auction
  belongs_to :user  

  validates :auction, :user, presence: true
  validate :auction_active?, message: :auction_active
  validate :last_user_different?

  private

  def auction_active?
    if auction && !auction.active?      
      if auction.finished?
        errors.add(:base, I18n.t('activerecord.errors.models.bid.auction_finished'))
      else
        errors.add(:base, I18n.t('activerecord.errors.models.bid.auction_not_started'))
      end
    end
  end

  def last_user_different?
    if auction && user
      errors.add(:base, I18n.t('activerecord.errors.models.bid.same_user_twice')) if auction.last_user == user
    end
  end
end
