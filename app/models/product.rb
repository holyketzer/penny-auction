class Product < ActiveRecord::Base
	validates :name, :presence => true
	validates :name, uniqueness: { case_sensitive: false }
  validates :description, :presence => true
  validates :shop_price, :presence => true
  validates :shop_price, numericality: { greater_than: 0.01 }
  validates :shop_price, fractionality: { greater_than: 0.01 }  
end
