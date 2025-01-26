class Order < ApplicationRecord
  enum status: { pending: 'pending', inprogress: 'inprogress', ready: 'ready', canceled: 'canceled'}

  before_create :generate_token

  belongs_to :table, class_name: "Serving::Table", foreign_key: :serving_table_id
  has_many :order_items, class_name: "Order::Item", foreign_key: :order_id

  private

  def generate_token
      self.token = SecureRandom.hex(10)
  end
end
