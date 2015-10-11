class CartProduct < ActiveRecord::Base
	belongs_to :user

	# return products in the cart of the current user
	def self.show_cart(page, current_user_id)
			@cart_products = order("created_at DESC").where(user_id: current_user_id)
			@show_cart_list = []
				@cart_products.each do |cart_product|
					show_cart_item = {}
					product = Product.find cart_product.product_id
					show_cart_item[:id] = cart_product.id
					show_cart_item[:title] = product.title
					show_cart_item[:price] = product.price
					show_cart_item[:total] = product.price * cart_product.quantity
					show_cart_item[:quantity] = cart_product.quantity
					show_cart_item[:stock] = product.quantity
					show_cart_item[:created_at] = cart_product.created_at
					@show_cart_list << show_cart_item
				end
			@show_cart_list.paginate(page: page, per_page: 5)
	end

=begin
	 if the same product exists in the cart, return the CartProduct
	 else return nil
=end
	def self.ifSameProductExist (productId, current_user_id)
		@cart_products = CartProduct.where(user_id: current_user_id)
		@cart_products.each do |cart_product|
			if cart_product.product_id.to_s == productId
				return cart_product
			end
		end
		return nil
	end

	def self.update_quantity(cartProductId, quantity)
			cartProduct = CartProduct.find cartProductId
			product = Product.find cartProduct.product_id
			if quantity <= product.quantity
				cartProduct.update(quantity: quantity)
				return quantity
			else
				return product.quantity
			end
	end
end

