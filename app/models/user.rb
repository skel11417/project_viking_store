class User < ApplicationRecord
  has_many :orders
  has_many :addresses
  has_many :products, through: :order_contents

  def default_billing_address_id
    billing_id
  end

  def default_shipping_address_id
    shipping_id
  end

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

  def self.highest_single_order
      select("users.first_name as first_name, users.last_name as last_name, (products.price * order_contents.quantity) AS total").
      joins("JOIN orders ON orders.user_id = users.id JOIN order_contents on order_contents.order_id = orders.id JOIN products ON order_contents.product_id = products.id").
      where("orders.checkout_date IS NOT NULL").
      group("first_name, last_name, total").
      order("total DESC").
      first
  end

  def self.highest_lifetime
    select("users.first_name as first_name, users.last_name as last_name, SUM(products.price * order_contents.quantity) AS total").
    joins("JOIN orders ON orders.user_id = users.id JOIN order_contents on order_contents.order_id = orders.id JOIN products ON order_contents.product_id = products.id").
    where("orders.checkout_date IS NOT NULL").
    group("first_name, last_name").
    order("total DESC").
    first
  end

  def self.highest_average_order
    select("users.first_name as first_name, users.last_name as last_name , SUM(products.price * order_contents.quantity)/(count (distinct orders.id)) as total").
    joins("JOIN orders ON orders.user_id = users.id JOIN order_contents on order_contents.order_id = orders.id JOIN products ON order_contents.product_id = products.id").
    where("orders.checkout_date IS NOT NULL").
    group("first_name, last_name").
    order("total DESC").
    first
  end

  def self.most_orders
    select("users.first_name as first_name, users.last_name as last_name, count(distinct orders.id) as total").
    joins("JOIN orders on orders.user_id = users.id").
    where("orders.checkout_date IS NOT NULL").
    group("first_name, last_name").
    order("total DESC").
    first
  end

end
