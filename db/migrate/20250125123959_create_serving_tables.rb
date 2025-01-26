class CreateServingTables < ActiveRecord::Migration[7.1]
  def change
    create_enum :serving_table_status, %w[active inactive]
    
    create_table :serving_tables do |t|
      t.string :token
      t.string :name
      t.string :location
      t.enum :status, enum_type: :serving_table_status, null: false, default: 'inactive'

      t.timestamps
    end
  end
end
