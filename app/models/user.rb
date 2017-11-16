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

end
