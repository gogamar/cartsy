class Product < ApplicationRecord
  has_many :pricing_rules, dependent: :destroy
  has_and_belongs_to_many :pricing_rules

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
