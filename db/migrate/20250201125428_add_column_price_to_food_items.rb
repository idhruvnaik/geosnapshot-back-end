class AddColumnPriceToFoodItems < ActiveRecord::Migration[7.1]
  def change
    add_column :food_items, :price, :float, default: 0.0
  end
end
