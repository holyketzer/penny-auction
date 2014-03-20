class Permission < ActiveRecord::Base
  validates :name, :action, :subject, presence: true

  belongs_to :role
end
