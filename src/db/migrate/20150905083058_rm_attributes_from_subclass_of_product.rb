class RmAttributesFromSubclassOfProduct < ActiveRecord::Migration
  def change
  	remove_column :books, :product_id
	remove_column :cloths, :product_id
	remove_column :snacks, :product_id
  end
end
