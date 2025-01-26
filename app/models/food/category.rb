class Food::Category < ApplicationRecord
  enum status: { active: "active", inactive: "inactive" }

  before_create :generate_token

  has_many :food_items, class_name: "Food::Item", foreign_key: :food_category_id

  private

  def generate_token
    self.token = SecureRandom.hex(10)
  end
end
