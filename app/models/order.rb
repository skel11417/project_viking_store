class Order < ApplicationRecord
  belongs_to :user
  has_many :order_contents
  has_many :products, through: :order_contents

  def value
    sum = 0
    order_contents.each do |item|
      sum += item.quantity * item.product.price
    end
    sum
  end

  def status
    checkout_date ? "PLACED" : "UNPLACED"
  end

  def self.num_orders(num_days=nil)
    if num_days
      Order.where("created_at > ?", Time.now - num_days.days).count
    else
      Order.count
    end
  end

  def self.avg_value(num_days=nil)
    if num_days
      joins("JOIN order_contents ON order_contents.order_id = orders.id JOIN products on order_contents.product_id = products.id").
      where("orders.checkout_date > ?", Time.now - num_days.days).
      average("(products.price * order_contents.quantity)")
    else
      joins("JOIN order_contents ON order_contents.order_id = orders.id JOIN products on order_contents.product_id = products.id").
      where.not('orders.checkout_date' => nil).
      average("(products.price * order_contents.quantity)")
    end
  end

  def self.largest_value(num_days=nil)
    if num_days
      Order.select("(products.price * order_contents.quantity) as order_total").
      joins("JOIN order_contents ON order_contents.order_id = orders.id JOIN products on order_contents.product_id = products.id").
      where("orders.checkout_date > ?", Time.now - num_days.days).
      group("order_total").
      order("order_total DESC").
      first
    else
      Order.select("(products.price * order_contents.quantity) as order_total").
      joins("JOIN order_contents ON order_contents.order_id = orders.id JOIN products on order_contents.product_id = products.id").
      where.not('orders.checkout_date' => nil).
      group("order_total").
      order("order_total DESC").
      first
    end
  end

  def self.orders_on_day(day_offset)
    select(:id).
    where(:checkout_date => (Time.now.midnight - day_offset.days)..(Time.now.midnight + 1.day - day_offset.days)).
    count
  end

  def self.revenue_on_day(day_offset)
    joins("JOIN order_contents ON order_contents.order_id = orders.id JOIN products on order_contents.product_id = products.id").
    where(:checkout_date => (Time.now.midnight - day_offset.days)..(Time.now.midnight + 1.day - day_offset.days)).
    sum("(order_contents.quantity * products.price)")
  end

  def self.orders_in_week(week_offset)
    select(:id).
    where(:checkout_date => (Time.now.midnight - 1.weeks - week_offset.weeks)..(Time.now.midnight - week_offset.weeks)).
    count
  end

  def self.revenue_in_week(week_offset)
    joins("JOIN order_contents ON order_contents.order_id = orders.id JOIN products on order_contents.product_id = products.id").
    where(:checkout_date => (Time.now.midnight - 1.weeks - week_offset.weeks)..(Time.now.midnight - week_offset.weeks)).
    sum("(order_contents.quantity * products.price)")
  end

end
