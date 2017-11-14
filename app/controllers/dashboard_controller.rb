class DashboardController < ApplicationController
  def index
    @users = User.all
    @total_num_users = User.count
    @total_num_orders = Order.count
    @total_num_products = Product.count
    @total_revenue = OrderContent.joins("INNER JOIN products ON products.id = order_contents.product_id")
      # @total_revenue = Order.find_by_sql("SELECT price FROM orders JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON products.id = order_contents.product_id")

  end
end
