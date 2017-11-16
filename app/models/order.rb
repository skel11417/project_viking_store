class Order < ApplicationRecord
  has_many :order_contents
  has_many :products, through: :order_contents

  def self.num_orders(num_days=nil)
    if num_days
      Order.where("created_at > ?", Time.now - num_days.days).count
    else
      Order.count
    end
  end
end
