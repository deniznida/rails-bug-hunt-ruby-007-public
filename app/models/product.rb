class Product < ActiveRecord::Base
  has_many :product_orders
  has_many :orders, through: :product_orders,
                    before_add: :decrement_amount_in_stock!,
                    before_remove: :increment_amount_in_stock!

  validates :amount_in_stock, numericality: { greater_than_or_equal_to: 0 }

  def self.in_stock
    self.where('amount_in_stock > 0')
  end

  def self.out_of_stock
    self.where(amount_in_stock: 0)
  end

  def decrement_amount_in_stock!(order=nil)
    self.amount_in_stock -= 1
    save!
  end

  def increment_amount_in_stock!(order=nil)
    self.amount_in_stock += 1
    save!
  end
end
