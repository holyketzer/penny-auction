class Image < ActiveRecord::Base
  scope :unengaged, -> { where("imageable_id IS NULL") }

  belongs_to :imageable, polymorphic: true

  mount_uploader :source, ImageUploader  

  def thumb_url
    source.thumb.url
  end
end
