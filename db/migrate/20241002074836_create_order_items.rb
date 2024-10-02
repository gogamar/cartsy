class CreateOrderItems < ActiveRecord::Migration[7.2]
  def change
    create_table :order_items do |t|
      t.decimal :price_per_item, precision: 10, scale: 2, null: false
      t.integer :quantity, null: false, default: 1
      t.decimal :discount_amount, precision: 10, scale: 2, default: 0.0
      t.decimal :total_price, precision: 10, scale: 2, null: false
      t.references :product, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
