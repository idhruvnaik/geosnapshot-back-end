class Order::Item < ApplicationRecord
  before_create :generate_token

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  belongs_to :food_item, class_name: "Food::Item", foreign_key: :food_item_id
  belongs_to :order, class_name: "Order", foreign_key: :order_id

  private

  def generate_token
    self.token = SecureRandom.hex(10)
  end
end
