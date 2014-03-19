class Role < ActiveRecord::Base
  has_many :users

  def self.default_role
    find_by name: 'user'
  end
end