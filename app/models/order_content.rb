class OrderContent < ApplicationRecord
  belongs_to :order
  belongs_to :product


  def self.revenue(num_days=nil)
    if num_days
      joins(
      "JOIN products ON products.id = order_contents.product_id
      JOIN orders ON orders.id = order_contents.order_id").where("orders.checkout_date > ?", Time.now - num_days.days).sum("(products.price * order_contents.quantity)")
    else
      joins(
      "JOIN products ON products.id = order_contents.product_id
      JOIN orders ON orders.id = order_contents.order_id").where.not('orders.checkout_date' => nil).sum("(products.price * order_contents.quantity)")
    end
  end


end
