class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :buyer_id
      t.integer :seller_id
      t.string :status
      t.float :total_price
      t.integer :postcode
      t.string :address
      t.string :phone

      t.timestamps null: false
    end
  end
end
