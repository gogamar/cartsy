FactoryBot.define do
  factory :pricing_rule do
    min_quantity { 3 }
    discount_amount { 2 }
    free_items { nil }
    description { "Buy #{min_quantity}, get #{discount_amount} off each" }

    trait :with_free_items do
      free_items { 1 }
      description { "Buy #{min_quantity}, get #{free_items} free" }
    end
  end
end
