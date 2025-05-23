class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  validates :title, presence: true
  validates :content, presence: true

  scope :published, -> { where.not(published_at: nil) }
  scope :draft, -> { where(published_at: nil) }
end
