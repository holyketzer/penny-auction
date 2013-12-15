class Image < ActiveRecord::Base
  validates :description, presence: true

  belongs_to :imageable, polymorphic: true

  mount_uploader :source, ImageUploader
end
