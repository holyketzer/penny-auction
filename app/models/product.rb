class Product < ActiveRecord::Base
  validates :name, :description, :shop_price, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :shop_price, numericality: { greater_than_or_equal_to: 0.01 }
  validates :shop_price, fractionality: { multiplier: 0.01 }

  belongs_to :category
end
