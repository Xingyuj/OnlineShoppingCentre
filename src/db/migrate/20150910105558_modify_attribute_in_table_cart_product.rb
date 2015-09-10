class ModifyAttributeInTableCartProduct < ActiveRecord::Migration
  def change
  	rename_column :cart_products, :cart_id, :user_id
  end
end
