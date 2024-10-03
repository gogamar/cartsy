require 'rails_helper'

RSpec.describe CartService do
  let(:session) { {} }
  let(:service) { CartService.new(session) }

  describe '#initialize' do
    context 'with an empty session' do
      it 'initializes with an empty cart' do
        expect(service.cart_items).to eq({})
      end
    end

    context 'with existing cart items' do
      let(:session) { { cart: { '1' => { 'quantity' => 2, 'total_price' => 20 } } } }

      it 'initializes with existing cart items' do
        expect(service.cart_items).to eq({ '1' => { quantity: 2, total_price: 20 } })
      end
    end
  end

  describe '#add_product' do
    let(:product) { create(:product, price: 10) }

    it 'adds a product to the cart' do
      service.add_product(product.id, 2)
      expect(service.cart_items[product.id.to_s]).to include(quantity: 2)
    end

    it 'updates quantity if product already in cart' do
      service.add_product(product.id, 2)
      service.add_product(product.id, 3)
      expect(service.cart_items[product.id.to_s]).to include(quantity: 3)
    end

    it 'removes product if quantity is 0' do
      service.add_product(product.id, 2)
      service.add_product(product.id, 0)
      expect(service.cart_items).not_to have_key(product.id.to_s)
    end

    it 'calculates total price correctly' do
      service.add_product(product.id, 2)
      expect(service.cart_items[product.id.to_s][:total_price]).to eq(20)
    end

    it 'includes discount description and price with discount' do
      service.add_product(product.id, 2)
      expect(service.cart_items[product.id.to_s]).to include(
        discount_description: "",
        price_with_discount: nil
      )
    end
  end

  describe '#calculate_discount' do
    let(:product) { create(:product, price: 10) }

    context 'with no discount rules' do
      it 'returns regular price' do
        result = service.calculate_discount(product, 2)
        expect(result[:total_price]).to eq(20)
        expect(result[:discount_description]).to eq("")
        expect(result[:price_with_discount]).to be_nil
      end
    end

    context 'with discount rules' do
      let!(:discount_rule) { create(:pricing_rule, min_quantity: 3, discount_amount: 2) }

      before do
        # Associate the pricing rule with the product
        product.pricing_rules << discount_rule
      end

      it 'applies discount when minimum quantity is met' do
        result = service.calculate_discount(product, 3)
        expect(result[:price_with_discount]).to eq(8)
        expect(result[:total_price]).to eq(24)
        expect(result[:discount_description]).to eq(discount_rule.description)
      end

      it 'does not apply discount when minimum quantity is not met' do
        result = service.calculate_discount(product, 2)
        expect(result[:price_with_discount]).to be_nil
        expect(result[:total_price]).to eq(20)
        expect(result[:discount_description]).to eq("")
      end
    end

    context 'with free items rule' do
      let!(:free_item_rule) { create(:pricing_rule, :with_free_items, min_quantity: 2, free_items: 1) }

      before do
        product.pricing_rules << free_item_rule
      end

      it 'adds free items when minimum quantity is met' do
        service.add_product(product.id, 2)
        expect(service.cart_items).to have_key("#{product.id}_free")
        expect(service.cart_items["#{product.id}_free"][:quantity]).to eq(1)
      end
    end
  end

  describe '#cart_total_price' do
    let(:product1) { create(:product, price: 10) }
    let(:product2) { create(:product, price: 15) }

    it 'calculates total price of all items in cart' do
      service.add_product(product1.id, 1)
      service.add_product(product2.id, 2)             # Debug output

      expected_total = service.cart_items.values.sum { |item| item[:total_price].to_f }
      expect(service.cart_total_price).to eq(expected_total)
    end
  end

  describe '#clear' do
    it 'removes all items from the cart' do
      service.add_product(create(:product).id, 2)
      service.clear
      expect(service.cart_items).to be_empty
    end
  end
end
