class Product < ApplicationRecord
  has_many :order_contents
  has_many :orders, through: :order_contents

  # has_many :users, :through => :order_contents

  belongs_to :category

  validates :name, :price, :category_id,
    :presence => true
  validates :price, numericality: {:less_than_or_equal_to => 10000}


  def price=(new_price)
    price = new_price.gsub("$", "")
    super(price.to_f)
  end

  def self.num_products(num_days=nil)
    if num_days
      Product.where("created_at > ?", Time.now - num_days.days).count
    else
      Product.count
    end
  end


end
