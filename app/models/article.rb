class Article < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :likes, dependent: :destroy
  scope :ordered_by_most_recent, -> { order(created_at: :desc) }
end
