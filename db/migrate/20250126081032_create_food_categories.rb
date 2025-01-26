class CreateFoodCategories < ActiveRecord::Migration[7.1]
  def change
    create_enum :food_category_status, %w[active inactive]

    create_table :food_categories do |t|
      t.string :name
      t.text :description
      t.string :image
      t.string :token
      t.enum :status, enum_type: :food_category_status, null: false, default: 'inactive'

      t.timestamps
    end
  end
end
