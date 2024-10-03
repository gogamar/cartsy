class CartService
  def initialize(session)
    @session = session
    @cart_items = session[:cart] ||= {}
  end

  def add_product(product_id, quantity)
    quantity = quantity.to_i
    puts "Quantity is here: #{quantity}"
    if quantity > 0
      @cart_items[product_id.to_s] = quantity
    elsif quantity == 0
      @cart_items.delete(product_id.to_s) # Remove product if quantity is 0
    end
    @session[:cart] = @cart_items
  end

  def total_price(products)
    @cart_items.reduce(0) do |total, (product_id, quantity)|
      product = products.find { |p| p.id == product_id.to_i }
      if product
        total + (product.price * quantity)
      else
        total  # Keep the total unchanged if product is not found
      end
    end
  end

  def cart_items
    @cart_items
  end

  def clear
    @cart_items.clear
    @session[:cart] = {}
  end
end
