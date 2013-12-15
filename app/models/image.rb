class Image < ActiveRecord::Base
  #validates :source, presence: true

  belongs_to :imageable, polymorphic: true

  mount_uploader :source, ImageUploader

  scope :unengaged, -> { where("imageable_id IS NULL") }

  def thumb_url
    source.thumb.url
  end
end
