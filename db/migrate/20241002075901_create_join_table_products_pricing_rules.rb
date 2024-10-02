class CreateJoinTableProductsPricingRules < ActiveRecord::Migration[7.2]
  def change
    create_join_table :products, :pricing_rules do |t|
      t.index :product_id
      t.index :pricing_rule_id
    end
  end
end
