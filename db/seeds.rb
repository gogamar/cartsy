Order.destroy_all
Product.destroy_all
PricingRule.destroy_all

products = [
  { code: "GR1", name: "Green Tea", price: 3.11, image_url: "https://images.unsplash.com/photo-1606377695906-236fdfcef767?q=80&w=220"},
  { code: "SR1", name: "Strawberries", price: 5.00, image_url: "https://images.unsplash.com/photo-1503624280608-6b79dc9ab03d?q=80&w=220" },
  { code: "CF1", name: "Coffee", price: 11.23, image_url: "https://plus.unsplash.com/premium_photo-1673545518947-ddf3240090b1?q=80&w=220" }
]

products.each do |product_data|
  Product.create!(product_data)
end

pricing_rules = [
  { rule_type: "buy_one_get_one_free", min_quantity: 1, discount_amount: nil, discount_percentage: nil, free_items: 1, description: "Buy one get one free" },
  { rule_type: "bulk_discount_10_percent", min_quantity: 3, discount_amount: nil, discount_percentage: 10.00, free_items: nil, description: "Save 10% when you buy 3 or more" },
  { rule_type: "bulk_discount_33_percent", min_quantity: 3, discount_amount: nil, discount_percentage: 33.33, free_items: nil, description: "Save 1/3 of the price when you buy 3 or more" }
]

pricing_rules.each do |rule_data|
  PricingRule.create!(rule_data)
end

Product.find_by(code: "GR1").pricing_rules << PricingRule.find_by(rule_type: "buy_one_get_one_free")
Product.find_by(code: "SR1").pricing_rules << PricingRule.find_by(rule_type: "bulk_discount_10_percent")
Product.find_by(code: "CF1").pricing_rules << PricingRule.find_by(rule_type: "bulk_discount_33_percent")

puts "Seeded #{Product.count} products and #{PricingRule.count} pricing rules."
