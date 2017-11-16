module DashboardHelper
  # def num_orders(num_days=nil)
  #   if num_days
  #     Order.where(orders: { created_at: time_range(num_days)}).count
  #   else
  #     Order.count
  #   end
  # end
  #
  # def num_products(num_days=nil)
  #   if num_days
  #     Product.where(products: { created_at: time_range(num_days)}).count
  #   else
  #     Product.count
  #   end
  # end

  # def revenue(num_days=nil)
  #   if num_days
  #     "chick file"
  #   else
  #       Order.where.not(:checkout_date => nil).joins(:order_contents)
  #       Order.joins(:order_contents)
  #
  #   end
  # end

  def time_range(num_days)
    (Time.now.midnight - num_days.day)..Time.now.midnight
  end

end
