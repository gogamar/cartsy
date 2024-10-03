class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def add_to_cart
    @products = Product.all
    product_id = params[:product_id]
    quantity = params[:quantity]

    @cart.add_product(product_id, quantity)

    respond_to do |format|
      format.html { redirect_to products_path, notice: 'Product added to cart.' }
      format.js { render partial: 'products/cart', locals: { cart: @cart, products: @products } }
    end
  end

  def checkout
    @order = Order.create(status: 'Pending')
    @order.add_items(@cart)
    @order.total_price = @order.calculate_total_price
    @order.save
    if @order.save
      redirect_to order_path(@order)
    else
      redirect_to products_path, alert: 'Failed to create order.'
    end
  end
end
