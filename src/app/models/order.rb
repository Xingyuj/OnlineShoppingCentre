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

	def self.create_cart_orders cart_products, current_user_id, cart_order_params
		seller_orders = {}
		Order.transaction do
			cart_products.each do |cart_product_id|
		      cart_product = CartProduct.find cart_product_id
		      product = Product.find cart_product.product_id
	      	  product.update_attributes(quantity: product[:quantity]-cart_product[:quantity])
		      if seller_orders.has_key? product.seller_id
		      	attrs = {product_id: cart_product[:product_id], amount: cart_product[:quantity]}
	   			order_product = OrderProduct.new attrs
		      	seller_orders[product.seller_id].order_products << order_product
		      else
		      	attrs = {"product_id" => cart_product.product_id, "current_user_id" => current_user_id, "amount" => cart_product[:quantity]}
		      	attrs.merge! cart_order_params
		      	order = Order.new attrs
		      	seller_orders[product.seller_id] = order
		      end
	   		end
	   		seller_orders.each do |seller, order|
	   			if order.save
	   				@message = "success"
	   			else
	   				@message = "seller_id: " + seller + "'s order: " + order.to_s + "fail to generated!"
	   			end
	   		end
   		end
   		return @message
	end

	private :set_attributes
end
