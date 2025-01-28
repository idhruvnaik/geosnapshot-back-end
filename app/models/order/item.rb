class Order::Item < ApplicationRecord
  before_create :generate_token

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :food_item, class_name: "Food::Item", foreign_key: :food_item_id
  belongs_to :order, class_name: "Order", foreign_key: :order_id

  after_commit :update_total_price

  private

  def update_total_price
    total_price = self.order.order_items.sum('quantity * price')
    total_price = total_price.round(2)
    order.update!(total_price: total_price)
  end

  def generate_token
    self.token = SecureRandom.hex(10)
  end
end
