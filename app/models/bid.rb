class Bid < ActiveRecord::Base
  belongs_to :auction
  belongs_to :user  

  validates :auction, :user, presence: true  
end
