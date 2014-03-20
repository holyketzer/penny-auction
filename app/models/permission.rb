class Permission < ActiveRecord::Base
  validates :name, :action, :subject, presence: true
end
