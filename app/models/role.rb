class Role < ActiveRecord::Base
  has_many :users
  has_many :permissions

  validates :name, presence: true

  def self.default_role
    find_by name: 'user'
  end
end