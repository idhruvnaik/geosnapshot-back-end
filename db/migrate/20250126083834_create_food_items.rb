class CreateFoodItems < ActiveRecord::Migration[7.1]
  def change
    create_enum :food_item_status, %w[active inactive]

    create_table :food_items do |t|
      t.string :name
      t.string :token
      t.enum :status, enum_type: :food_item_status, null: false, default: 'inactive'
      t.text :description
      t.string :serving
      t.references :food_category, null: false, foreign_key: true
      t.string :image

      t.timestamps
    end
  end
end
