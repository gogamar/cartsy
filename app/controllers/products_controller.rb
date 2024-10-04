class ProductsController < ApplicationController
  def index
    @products = Product.all
    @sorted_cart_items = @cart.cart_items.sort_by do |key, details|
      # Criteria: move items with '_free' in the key or total_price == 0 to the end
      [key.include?('_free') ? 1 : 0, key]
    end.to_h
  end

  def add_to_cart
    @products = Product.all
    product_id = params[:product_id]
    quantity = params[:quantity]

    @cart.add_product(product_id, quantity)

    respond_to do |format|
      format.html { redirect_to products_path }
      format.js { render partial: "products/cart", locals: { cart: @cart, products: @products } }
    end
  end

  def checkout
    @order = Order.create(status: "Pending")
    @order.add_items(@cart)
    @order.total_price = @order.calculate_total_price
    @order.total_discount = @order.calculate_total_discount
    @order.save
    if @order.save
      redirect_to order_path(@order)
    else
      redirect_to products_path, alert: "Failed to create order."
    end
  end
end
