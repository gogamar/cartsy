Product.destroy_all
PricingRule.destroy_all

products = [
  { code: 'GR1', name: 'Green Tea', price: 3.11 },
  { code: 'SR1', name: 'Strawberries', price: 5.00 },
  { code: 'CF1', name: 'Coffee', price: 11.23 }
]

products.each do |product_data|
  Product.create!(product_data)
end

pricing_rules = [
  { rule_type: 'buy_one_get_one_free', min_quantity: 1, discount_price: nil, discount_percentage: nil, free_items: 1 },
  { rule_type: 'bulk_discount_10_percent', min_quantity: 3, discount_price: nil, discount_percentage: 10.00, free_items: nil },
  { rule_type: 'bulk_discount_33_percent', min_quantity: 3, discount_price: nil, discount_percentage: 33.33, free_items: nil }
]

pricing_rules.each do |rule_data|
  PricingRule.create!(rule_data)
end

Product.find_by(code: 'GR1').pricing_rules << PricingRule.find_by(rule_type: 'buy_one_get_one_free')
Product.find_by(code: 'SR1').pricing_rules << PricingRule.find_by(rule_type: 'bulk_discount_10_percent')
Product.find_by(code: 'CF1').pricing_rules << PricingRule.find_by(rule_type: 'bulk_discount_33_percent')

puts "Seeded #{Product.count} products and #{PricingRule.count} pricing rules."
