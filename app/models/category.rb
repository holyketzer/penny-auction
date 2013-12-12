class Category < ActiveRecord::Base
	has_ancestry

	validates :name, :presence => true
	validates :name, uniqueness: { case_sensitive: false }
  validates :description, :presence => true
end
