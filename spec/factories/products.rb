FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    sequence(:code) { |n| "PROD#{n}" }
    price { 10 }

    trait :with_pricing_rule do
      after(:create) do |product|
        product.pricing_rules << create(:pricing_rule)
      end
    end
  end
end
