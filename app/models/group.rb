class Group < ApplicationRecord
  validates :banner, :description, :genre, presence: true
  belongs_to :user
  has_many :join_groups
  enum genre: [:general, :hidden]
  mount_uploader :banner, ImageUploader
end