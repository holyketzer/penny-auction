class Product < ActiveRecord::Base
  validates :name, :description, :shop_price, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :shop_price, numericality: { greater_than: 0.01 }
  validates :shop_price, fractionality: { greater_than: 0.01 }  
end
