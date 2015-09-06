class RmAttributeNameInBooks < ActiveRecord::Migration
  def change
	  remove_column :books, :name
  end
end
