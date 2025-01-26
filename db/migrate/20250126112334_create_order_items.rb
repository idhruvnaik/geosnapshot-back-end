class CreateOrderItems < ActiveRecord::Migration[7.1]
  def change
    create_table :order_items do |t|
      t.string :token
      t.references :food_item, null: false, foreign_key: true
      t.float :quantity
      t.references :order, null: false, foreign_key: true
      t.float :price
      t.string :instructions

      t.timestamps
    end
  end
end
