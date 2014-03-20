class Role < ActiveRecord::Base
  has_many :role_permissions
  has_many :permissions, through: :role_permissions

  validates :name, presence: true

  def self.default_role
    find_by name: 'user'
  end
end