class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :reference
      t.string :client_name
      t.string :address
      t.decimal :total_value
      t.jsonb :line_items, array: true
      t.integer :status, default: 1
      t.string :purchase_channel
      t.string :delivery_service
      t.references :batch

      t.timestamps
    end
  end
end
