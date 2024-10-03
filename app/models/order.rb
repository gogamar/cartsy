class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy

  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }, if: :confirmed?

  def add_items(cart)
    cart.cart_items.each do |product_id, quantity|

      product = Product.find(product_id.to_i)

      OrderItem.create(
        price_per_item: product.price,
        quantity: quantity,
        total_price: product.price * quantity,
        product_id: product.id,
        order_id: id,
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
