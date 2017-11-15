class Order < ApplicationRecord
  has_many :order_contents
  has_many :products, through: :order_contents
end
