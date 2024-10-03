class RenameDiscountPriceToDiscountAmount < ActiveRecord::Migration[7.2]
  def change
    rename_column :pricing_rules, :discount_price, :discount_amount
  end
end
