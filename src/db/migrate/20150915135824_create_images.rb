class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :product_id
      t.string :path
      t.string :image_type

      t.timestamps null: false
    end
  end
end
