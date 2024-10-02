class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.string :status
      t.decimal :total_discount, precision: 10, scale: 2, default: 0.0
      t.decimal :total_price, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
