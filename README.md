# Cartsy - Cash Register Application

## Overview

Cartsy is a simple cash register application built with Ruby on Rails. It calculates the total price of items added to a cart, applying specific pricing rules. Cartsy includes a standalone ruby.rb script that can be executed from the command line for testing or standalone usage.
<br>


## Ruby Version

The application is built with Ruby version `3.2.2`.

## System Dependencies

The following gems are required for the application:

- `factory_bot_rails` - Fixtures replacement for Rails.
- `rspec-rails` (~> 6.1.4) - RSpec testing framework for Rails.

## Configuration

- Run `rails db:create` to create the database.
- Run `rails db:migrate` to migrate the database.
- Run `rails db:seed` to seed the database.

## How to run the tests

To run the tests, make sure you have RSpec and FactoryBot set up.
Then execute `bundle exec rspec`

## Features

- Add products to cart
- Apply dynamic pricing rules
- Calculate totals with discounts
- Session-based cart persistence
- Simple and intuitive user interface

### Data Model

```
Product --< OrderItem >-- Order
|
v
PricingRule
```

### Key Components

- **Product**: Represents items available for purchase.
- **PricingRule**: Defines special pricing or discount rules for products.
- **Order**: Represents a purchase. Can have status pending or confirmed.
- **OrderItem**: Represents individual items within an order.
- **CartService**: A service class located in `app/services/cart_service.rb` that handles the business logic for cart management. It holds the items added during the session, applies pricing rules and calculates totals, without storing any data in the database.

## Design Decisions

1. **No Cart Model in the Database**: We use a plain Ruby class to represent the cart's state, avoiding unnecessary database complexity.

2. **Session-Based Cart Storage**: Each user's cart persists only while their session is active, providing a stateless and scalable solution.

3. **Extendability**: The current design can be easily extended to handle more complex cart-related logic, such as advanced discounts or promotions.

## Installation

1. Clone the repository:

   ```
   git clone https://github.com/your-username/cartsy.git
   cd cartsy
   ```

## Usage

In the Browser

1. Browse available products on the home page.
2. Add items to your cart.
3. Proceed to checkout to review your order - the current total and applied discounts.
4. Confirm the order to complete your purchase.

In the CLI

`ruby cart.rb add PRODUCT_CODE QUANTITY`

Example Usage:
`ruby cart.rb add CF1 3`

Run to see the commands and examples:
`ruby cart.rb help`

## To Do

CRUD for Pricing Rules: Implement full Create, Read, Update, and Delete (CRUD) actions for managing pricing rules assuring flexibility.

Validation Logic: Ensure that the attributes `discount_amount`, `discount_percentage`, and `free_items` are mutually exclusive. If one of these attributes is used, the other two should be automatically rejected.
