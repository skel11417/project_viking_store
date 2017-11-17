module DashboardHelper

  def overall_platform(days=nil)
      [["New Users", User.num_users(days)],
        ["Orders", Order.num_orders(days)],
        ["New Products", Product.num_products(days)],
        ["Revenue", "$#{OrderContent.revenue(days)}"]
      ]
  end

  def order_statistics(days=nil)
      [["Number of Orders", Order.num_orders(days)],
        ["Total Revenue", "$#{OrderContent.revenue(days)}"],
        ["Average Order Value", "$#{Order.avg_value(days)}"],
        ["Largest Order Value", "$#{Order.largest_value(days).order_total}"]
      ]
  end



  # def time_range(num_days)
  #   (Time.now.midnight - num_days.day)..Time.now.midnight
  # end

end
