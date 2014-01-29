class Auction < ActiveRecord::Base
  belongs_to :product
  belongs_to :image
end