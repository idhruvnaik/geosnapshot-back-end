class Food::Item < ApplicationRecord
  enum status: { active: 'active', inactive: 'inactive'}

  before_create :generate_token

  belongs_to :category, class_name: "Food::Category", foreign_key: :food_category_id

  private

  def generate_token
      self.token = SecureRandom.hex(10)
  end
end
