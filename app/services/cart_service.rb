class CartService
  def initialize(session)
    @session = session
    @cart_items = session[:cart] ||= {}
  end

  def add_product(product_id, quantity)
    quantity = quantity.to_i
    @cart_items[product_id.to_s] = quantity if quantity > 0
    @session[:cart] = @cart_items
  end

  def cart_items
    @cart_items
  end

  def total_price(products)
    @cart_items.reduce(0) do |total, (product_id, quantity)|
      product = products.find { |p| p.id == product_id.to_i }
      total + (product.price * quantity) if product
    end
  end

  def clear_cart
    @session[:cart] = {}
  end
end
