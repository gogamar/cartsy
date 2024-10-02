class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy

  validates :total_price, presence: true
end
