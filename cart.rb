require_relative 'config/environment'
require_relative 'app/services/cart_service'
require 'json'

class CartCLI
  CART_FILE = 'cart_data.json'

  def self.start
    load_session
    @cart_service = CartService.new(@session)

    if ARGV.empty?
      puts "Usage: ruby cart.rb [command] [arguments]"
      puts "Commands: add, checkout, clear, help"
      return
    end

    command = ARGV.shift
    case command
    when 'add'
      if ARGV.size == 2
        add_product(ARGV[0], ARGV[1].to_i)
      else
        puts "Usage: ruby cart.rb add PRODUCT_CODE QUANTITY"
      end
    when 'checkout'
      checkout
    when 'clear'
      clear_cart
    when 'help'
      show_help
    else
      puts "Unknown command. Use 'ruby cart.rb help' for usage information."
    end

    save_session
  end

  def self.load_session
    if File.exist?(CART_FILE)
      file_contents = File.read(CART_FILE)
      @session = JSON.parse(file_contents, symbolize_names: true)
    else
      @session = { cart: {} }
    end
  end

  def self.save_session
    File.write(CART_FILE, JSON.pretty_generate(@session))
  end

  def self.add_product(product_code, quantity)
    product = Product.find_by(code: product_code)
    if product
      @cart_service.add_product(product.id, quantity)
      puts "Added #{quantity} #{product.name}(s) to the cart."
      puts "To go to the checkout and process your order, type 'checkout'"

      confirmation = $stdin.gets.chomp

      if confirmation == 'checkout'
        checkout
      else
        puts "Do come back later and finish your purchase! You know where to find us!"
      end
    else
      puts "Product not found. Use 'ruby cart.rb help' to see all the options."
    end
  end

  def self.checkout
    cart_items = @cart_service.cart_items
    if cart_items.empty?
      puts "Cart is empty."
    else
      puts "Cart contents:"

      cart_items.each do |product_id, item_data|
        product = Product.find_by(id: product_id.to_s)

        puts "Product: #{product.name} - Price per item: #{item_data[:price_per_item].round(2)}€ - #{item_data[:price_with_discount] ? "Price with discount: #{item_data[:price_with_discount].round(2)}€ -" : ""} Quantity: #{item_data[:quantity]} - Total price: #{item_data[:total_price].round(2)}€ - #{item_data[:discount_description]}"
      end

      puts "Total: $#{@cart_service.cart_total_price.round(2)}"
      puts "To confirm the purchase, type 'confirm'"
      confirmation = $stdin.gets.chomp

      if confirmation == 'confirm'
        process_order(@cart_service)
      else
        puts "Purchase cancelled."
      end
    end
  end

  def self.process_order(cart)
    total_price = cart.cart_total_price.round(2)
    total_discount = cart.cart_total_discount.round(2)

    puts "Processing order for #{total_price}€..."
    if cart.cart_total_discount > 0
      puts "You have just saved: #{total_discount}€!!!"
    end

    order = Order.create!(
      total_price: total_price,
      total_discount: total_discount,
      status: 'Confirmed'
    )

    @cart_service.cart_items.each do |product_id, item_data|
      if product_id.to_s.include?("free")
        cleaned_product_id = product_id.to_s.gsub("_free", "").to_s
      else
        cleaned_product_id = product_id.to_s
      end

      product = Product.find_by(id: cleaned_product_id)

      OrderItem.create!(
        order: order,
        product: product,
        quantity: item_data[:quantity],
        price_per_item: item_data[:price_per_item],
        total_price: item_data[:total_price]
      )
    end

    puts "Order ##{order.id} processed successfully!"
    puts "Thank you for your purchase!"
    clear_cart
  rescue ActiveRecord::RecordInvalid => e
    puts "Error processing order: #{e.message}"
    clear_cart
  end

  def self.clear_cart
    @cart_service.clear
    puts "Cart cleared."
  end

  def self.display_products_and_rules
    puts "\nAvailable products and their pricing rules:"
    puts "-------------------------------------------"
    Product.all.each do |product|
      puts "#{product.name} (#{product.code}) - Price: €#{product.price.round(2)}€"
      if product.pricing_rules
        product.pricing_rules.each do |rule|
          puts "  Discount: #{rule.description}"
        end
      else
        puts "  No special discount"
      end
      puts ""
    end
    puts "\nTo add a product to the shopping cart, enter:"
    puts "ruby cart.rb add PRODUCT_CODE QUANTITY"
    puts "\nExample: ruby cart.rb add CF1 3"
  end

  def self.show_help
    puts "Usage: ruby cart.rb [command] [arguments]"
    puts "Commands:"
    puts "  add PRODUCT_CODE QUANTITY  - Add a product to the cart"
    puts "  checkout                   - Show cart contents and confirm purchase"
    puts "  clear                      - Clear the cart"
    puts "  help                       - Show this help message"

    display_products_and_rules
  end
end

CartCLI.start
