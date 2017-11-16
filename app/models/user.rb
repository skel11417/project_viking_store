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

end
