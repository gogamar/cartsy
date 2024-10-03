class ApplicationController < ActionController::Base
  before_action :initialize_cart

  private

  def initialize_cart
    @cart = CartService.new(session)
  end
end
