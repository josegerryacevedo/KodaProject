class Post < ApplicationRecord
  validates :title, :content, :image, presence: true
  belongs_to :user
  enum audience: [:general, :friend, :personal]
  mount_uploader :image, ImageUploader
end
