class Post < ApplicationRecord
  validates :title, :content, :image, :audience, presence: true
  belongs_to :user
  has_many :comments
  enum audience: [:general, :friend, :personal]
  mount_uploader :image, ImageUploader
end
