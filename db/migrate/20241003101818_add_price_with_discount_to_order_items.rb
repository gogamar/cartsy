class AddPriceWithDiscountToOrderItems < ActiveRecord::Migration[7.2]
  def change
    add_column :order_items, :price_with_discount, :decimal, precision: 10, scale: 2
  end
end
