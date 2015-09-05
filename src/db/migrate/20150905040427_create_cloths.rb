class CreateCloths < ActiveRecord::Migration
  def change
    create_table :cloths do |t|
      t.integer :product_id
      t.integer :size
      t.string :material
      t.string :brand
      t.string :condition
      t.string :garment_care

      t.timestamps null: false
    end
  end
end
