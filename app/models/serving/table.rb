class Serving::Table < ApplicationRecord
  enum status: { active: "active", inactive: "inactive" }

  before_create :generate_token

  scope :active, lambda { where(status: "active") }

  has_many :orders, class_name: "Order", foreign_key: :serving_table_id

  private

  def generate_token
    self.token = SecureRandom.hex(10)
  end
end
