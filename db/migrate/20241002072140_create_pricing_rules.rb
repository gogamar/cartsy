class CreatePricingRules < ActiveRecord::Migration[7.2]
  def change
    create_table :pricing_rules do |t|
      t.string :rule_type
      t.integer :min_quantity
      t.decimal :discount_price, precision: 10, scale: 2
      t.decimal :discount_percentage, precision: 5, scale: 2
      t.integer :free_items

      t.timestamps
    end
  end
end
