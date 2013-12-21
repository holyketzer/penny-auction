class Category < ActiveRecord::Base
  has_many :products
  has_one :image, as: :imageable
  
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :description, presence: true

  has_ancestry
end
