class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :seller_id
      t.string :name
      t.integer :quantity
      t.float :price
      t.string :description
      t.integer :actable_id
      t.string :actable_type

      t.timestamps null: false
    end
  end
end
