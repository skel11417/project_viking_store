class User < ApplicationRecord
  belongs_to :order

  def name
    "#{first_name} #{last_name}"
  end
end
