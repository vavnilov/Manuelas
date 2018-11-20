class UserProduct < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :product_id, presence: true
  validates :price, presence: true
  validates :quantity, presence: true
end
