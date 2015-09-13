class CartProduct < ActiveRecord::Base
	belongs_to :user

	# return products in the cart of the current user
	def self.show_cart(page, current_user_id)
			order("created_at DESC").where(user_id: current_user_id).all.paginate(page: page, per_page: 5)
	end
end

