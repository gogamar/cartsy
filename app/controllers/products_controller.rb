class ProductsController < ApplicationController
  def index
    @products = Product.all
    @cart_service = CartService.new(session)
  end

  def add_to_cart
    @cart_service = CartService.new(session)
    product_id = params[:product_id]  # Retrieve product_id from the hidden field
    quantity = params[:quantity]        # Retrieve the quantity

    @cart_service.add_product(product_id, quantity)
    redirect_to products_path
  end

  def checkout
    @cart_service = CartService.new(session)
    @products = Product.all
    total_price = @cart_service.total_price(@products)

    @order = Order.create(status: 'Confirmed', total_price: total_price)
    @cart_service.clear_cart

    redirect_to order_path(@order)
  end
end
