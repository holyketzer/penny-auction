class Role < ActiveRecord::Base
  has_many :role_permissions
  has_many :permissions, through: :role_permissions

  validates :name, presence: true

  def self.default_role
    find_by name: 'user'
  end

  def self.bot
    find_by name: 'bot'
  end

  def self.admin
    find_by name: 'admin'
  end
end