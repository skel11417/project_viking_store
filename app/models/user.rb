class User < ApplicationRecord
  belongs_to :order

  def name
    "#{first_name} #{last_name}"
  end

  def self.num_users(num_days=nil)
    if num_days
      User.where("created_at > ?", Time.now - num_days.days).count
    else
      User.count
    end
  end

  def self.top_3_states
    select("states.name as state_name, count(users.id) as all_users").
    joins("JOIN addresses ON users.billing_id = addresses.id
        JOIN states ON addresses.state_id = states.id").
    group("state_name").order("all_users DESC").limit(3)
  end

  def self.top_3_cities
    select("cities.name as city_name, count(users.id) as all_users").
    joins("JOIN addresses ON users.billing_id = addresses.id
        JOIN cities ON addresses.city_id = cities.id").
    group("city_name").order("all_users DESC").limit(3)
  end

  def self.highest_order
    # select("orders.user_id, (products.price * order_contents.quantity) as order_total").
    # joins("JOIN order_contents ON order_contents.order_id = orders.id JOIN products on order_contents.product_id = products.id").
    # where.not('orders.checkout_date' => nil).
    # group("order_total, orders.user_id").
    # order("order_total DESC").
    # limit(1)
  end

  def self.most_orders

  end

end
