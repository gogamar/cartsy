class CartService
  def initialize(session)
    @session = session
    @session[:cart] ||= {}
    @cart_items = symbolize_item_data(@session[:cart])
  end

  def add_product(product_id, quantity)
    quantity = quantity.to_i
    if quantity > 0
      product = Product.find(product_id)
      item_data = calculate_discount(product, quantity)
      @cart_items[product_id.to_s] = item_data
    elsif quantity == 0
      @cart_items.delete(product_id.to_s) # Remove product if quantity is 0
      remove_free_items(product_id)
    end
    @session[:cart] = @cart_items
  end

  def calculate_discount(product, quantity)
    price_per_item = product.price
    discount_amount = 0
    price_with_discount = nil
    discount_description = ""
    total_price = price_per_item * quantity

    if product.pricing_rules.any?
      discount_data = best_discount_data(product, quantity)
      best_rule = discount_data[:best_rule]
      best_discount = discount_data[:best_discount]
      best_price = discount_data[:best_price]

      if best_rule
        discount_description = best_rule.description
        discount_amount = best_discount
        if best_rule.free_items.present?
          recalculate_free_items(quantity, best_rule.min_quantity, best_rule.free_items, product.id)
        else
          price_with_discount = best_price
          total_price = price_with_discount * quantity
        end
      end
    end

    {
      price_per_item: price_per_item,
      discount_amount: discount_amount,
      price_with_discount: price_with_discount,
      quantity: quantity,
      total_price: total_price,
      discount_description: discount_description
    }
  end

  def cart_total_price
    @cart_items.values.sum { |item| item[:total_price].to_f }
  end

  def cart_total_discount
    @cart_items.values.sum { |item| item[:discount_amount].to_f }
  end

  def cart_items
    @cart_items
  end

  def clear
    @cart_items.clear
    @session[:cart] = {}
  end

  private

  def best_discount_data(product, quantity)
    best_rule = nil
    best_discount = 0
    best_price = nil

    product.pricing_rules.each do |rule|
      if rule.min_quantity.present? && quantity >= rule.min_quantity
        discount_amount = calculate_discount_amount(product.price, rule, quantity)
        if discount_amount > best_discount
          best_rule = rule
          best_discount = discount_amount
          best_price = product.price - (discount_amount / quantity)
        end
      end
    end

    { best_rule: best_rule, best_discount: best_discount, best_price: best_price }
  end

  def calculate_discount_amount(price_per_item, rule, quantity)
    if rule.discount_amount.present?
      rule.discount_amount * quantity
    elsif rule.discount_percentage.present?
      discount_perc_2_decimals = (rule.discount_percentage / 100).round(2)
      (price_per_item * discount_perc_2_decimals).round(2) * quantity
    elsif rule.free_items.present?
      price_per_item * rule.free_items * quantity
    else
      0
    end
  end

  def add_free_items(quantity, min_quantity, free_items_count, product_id)
    sets_of_free_items = quantity / min_quantity  # Number of complete sets for free items

    free_item_data = {
      quantity: free_items_count * sets_of_free_items,
      price_per_item: 0,
      total_price: 0,
      discount_amount: 0,
      discount_description: "Free item"
    }

    free_product_key = "#{product_id}_free"
    @cart_items[free_product_key] = free_item_data
    @session[:cart] = @cart_items
  end

  def remove_free_items(product_id)
    free_product_key = "#{product_id}_free"
    @cart_items.delete(free_product_key)
    @session[:cart] = @cart_items
  end

  def recalculate_free_items(quantity, min_quantity, free_items_count, product_id)
    if quantity >= min_quantity
      add_free_items(quantity, min_quantity, free_items_count, product_id)
    else
      remove_free_items(product_id)
    end
  end

  def symbolize_item_data(cart)
    cart.each_with_object({}) do |(product_id, item_data), hash|
      hash[product_id] = item_data.symbolize_keys
    end
  end
end
