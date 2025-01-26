class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_enum :order_status, %w[pending inprogress ready cancel]

    create_table :orders do |t|
      t.string :token
      t.references :serving_table, null: false, foreign_key: true
      t.enum :status, enum_type: :order_status, null: false, default: "pending"
      t.float :total_price
      t.string :estimated_time
      t.datetime :submission_time
      t.integer :sequence

      t.timestamps
    end
  end
end
