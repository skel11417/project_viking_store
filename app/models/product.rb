class Product < ApplicationRecord
  has_many :orders, through: :order_contents
  belongs_to :category
end
