class OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
    @sorted_order_items = @order.order_items.order(total_price: :desc)
  end

  def create
    @order = Order.create(status: "Pending")
    redirect_to order_path(@order)
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      @cart.clear
      redirect_to order_path(@order), notice: "Your order has been confirmed."
    else
      flash[:alert] = "There was an issue confirming your order. Please try again."
      redirect_to order_path(@order)
    end
  end

  private

  def order_params
    params.require(:order).permit(:status, :total_discount, :total_price)
  end
end
