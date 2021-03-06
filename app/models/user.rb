class User < ApplicationRecord
  validates :first_name, :last_name, :email, presence: true, length: {in: 1..64}
  validates :email, :format => {with: /@/, :message => "Email must include @"}


  has_many :orders
  has_many :credit_cards
  has_many :addresses
  belongs_to :billing_address, class_name: "Address", :foreign_key => :billing_id
  belongs_to :shipping_address, class_name: "Address", :foreign_key => :shipping_id
  has_many :products, through: :order_contents

  def default_billing_address_id
    billing_id
  end

  def default_shipping_address_id
    shipping_id
  end

  def bill_address_to_s
    address_to_s(billing_address)
  end

  def ship_address_to_s
    address_to_s(shipping_address)
  end

  def address_to_s(a)
    "#{a.street_address}, #{a.city.name}, #{a.state.name}, #{a.zip_code}"
  end

  def join_date
    created_at.strftime("%F")
  end

  def last_order_date
    d = orders.where("checkout_date IS NOT NULL").order("checkout_date DESC").first
    if d
      d.checkout_date.strftime("%F")
    else
      "n/a"
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def city
    shipping_address.city.name
  end

  def state
    shipping_address.state.name
  end

  def num_orders
     orders.where("checkout_date IS NOT NULL").count
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
