class CreateSnacks < ActiveRecord::Migration
  def change
    create_table :snacks do |t|
      t.integer :product_id
      t.datetime :manufacture_date
      t.datetime :best_before
      t.string :brand
      t.string :production_place
      t.string :ingredient
      t.string :weight

      t.timestamps null: false
    end
  end
end
