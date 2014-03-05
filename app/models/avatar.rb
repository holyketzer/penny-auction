class Avatar < ActiveRecord::Base
  belongs_to :user

  #validates :source, presence: true

  mount_uploader :source, AvatarUploader

  def thumb_url
    source.thumb.url
  end

  def small_thumb_url
    source.small_thumb.url
  end
end
