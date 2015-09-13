class Order < ActiveRecord::Base
	has_many :order_products

	# return the order list according to the correct type
	def self.show_order(type,page, current_user_id)
		if type == 'purchase'
			order("created_at DESC").where(buyer_id: current_user_id).paginate(page: page, per_page: 1)
		elsif type == 'purchase'
			order("created_at DESC").where(seller_id: current_user_id).paginate(page: page, per_page: 1)
		end
	end

	def initialize attributes = nil
		if attributes
			@amount = attributes["amount"]
			@current_user_id = attributes["current_user_id"]
			@product_id = attributes["product_id"]
			excludes = [ "current_user_id" ,"product_id", "amount"]
			attributes.except!( *excludes )
		end
		super attributes
		set_attributes unless attributes == nil
	end

	def set_attributes
		product = Product.find @product_id
		total_price = @amount.to_d * product.price.to_d
   		attributes = {buyer_id: @current_user_id, seller_id: product.seller_id, status: "unpaid", total_price: total_price}
   		self.attributes = attributes
   		attrs = {product_id: @product_id, quantity: @amount}
   		order_product = OrderProduct.new attrs
   		self.order_products << order_product
	end

	def decrease_correspoding_product
		product = Product.find @product_id
		product.update_attributes(quantity: product.quantity-@amount.to_d)
	end
end
