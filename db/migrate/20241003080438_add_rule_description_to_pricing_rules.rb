class AddRuleDescriptionToPricingRules < ActiveRecord::Migration[7.2]
  def change
    add_column :pricing_rules, :description, :string
  end
end
