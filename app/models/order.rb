class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy

  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: :confirmed?

  def add_items(cart)
    cart.cart_items.each do |product_id, item_data|
      OrderItem.create(
        price_per_item: item_data[:price_per_item],
        price_with_discount: item_data[:price_with_discount],
        quantity: item_data[:quantity],
        discount_amount: item_data[:discount_amount],
        total_price: item_data[:total_price],
        product_id: product_id,
        order_id: id
      )
    end
  end

  def confirmed?
    status == 'Confirmed'
  end

  # Method to calculate total price based on associated order items
  def calculate_total_price
    order_items.sum(&:total_price)
  end
end
