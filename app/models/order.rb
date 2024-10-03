class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy

  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: :confirmed?

  def add_items(cart)
    puts "these are the cart.cart_items...#{cart.cart_items}"
    cart.cart_items.each do |product_id, item_data|
      if product_id.to_s.include?('free')
        product_id = product_id.to_s.gsub('_free', '').to_i
      end
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

  def calculate_total_discount
    order_items.sum(&:discount_amount)
  end
end
