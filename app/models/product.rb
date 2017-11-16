class Product < ApplicationRecord
  has_many :orders, through: :order_contents
  belongs_to :category

  def self.num_products(num_days=nil)
    if num_days
      Product.where("created_at > ?", Time.now - num_days.days).count
    else
      Product.count
    end
  end
end
