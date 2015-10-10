class Order < ActiveRecord::Base
	has_many :order_products
	attr_reader :product_id, :amount


	# return the order list according to the correct type
	def self.show_order(type, page, current_user_id)
		if type == 'purchase'
			order("created_at DESC").where(buyer_id: current_user_id).paginate(page: page, per_page: 8)
		elsif type == 'purchase'
			order("created_at DESC").where(seller_id: current_user_id).paginate(page: page, per_page: 8)
		end
	end

=begin
Overwrite constructor of order calling private function set_attributes, enable generating OrderProduct for order.
@param attributes[optional]
=end

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

=begin
Private function set_attributes, called by initialise. create OrderProduct for generated order and set other attributes
=end
	def set_attributes
		product = Product.find @product_id
		total_price = @amount.to_d * product.price.to_d
   		attributes = {buyer_id: @current_user_id, seller_id: product.seller_id, status: "unpaid", total_price: total_price}
   		self.attributes = attributes
   		attrs = {product_id: @product_id, quantity: @amount}
   		order_product = OrderProduct.new attrs
   		self.order_products << order_product
	end

=begin
Used by “buy it now” feature, to decrease quantity of product after corresponding order is created.
=end
	def decrease_correspoding_product
		product = Product.find @product_id
		product.update_attributes!(quantity: product.quantity-@amount.to_i)
	end

=begin
Static method create_cart_orders, used for checkout from cart. This method using transaction to ensure 
orders of every selected product successfully created. Otherwise, rollback all operations and return error information.
@param cart_products, current_user_id, cart_order_params
=end
	def self.create_cart_orders cart_products, current_user_id, cart_order_params
		seller_orders = {}
		orders_generated = []
		Order.transaction do
			cart_products.each do |cart_product_id|
		      cart_product = CartProduct.find cart_product_id
		      product = Product.find cart_product.product_id
	      	  product.update_attributes(quantity: product[:quantity]-cart_product[:quantity])
		      if seller_orders.has_key? product.seller_id
		      	attrs = {product_id: cart_product[:product_id], quantity: cart_product[:quantity]}
	   			order_product = OrderProduct.new attrs
		      	seller_orders[product.seller_id].order_products << order_product
		      else
		      	attrs = {"product_id" => cart_product.product_id, "current_user_id" => current_user_id, "amount" => cart_product[:quantity]}
		      	attrs.merge! cart_order_params
		      	order = Order.new attrs
		      	seller_orders[product.seller_id] = order
		      end
		      CartProduct.destroy(cart_product_id)
	   		end
	   		seller_orders.each do |seller, order|
   				total_price = 0
	   			order.order_products.each do |order_product|
	   				product = Product.find order_product.product_id
	   				total_price += product.price*order_product.quantity
	   			end
	   			order.total_price = total_price
	   			if order.save_order
	   				@message = "success"
	   				orders_generated << order.id
	   			else
	   				@message = "seller_id: " + seller + "'s order: " + order.to_s + "fail to generated!"
	   			end
	   		end
   		end
   		return @message=="success"? orders_generated : @message
	end

=begin
save_order
Using transaction to ensure failure order generation will not influence quantity of product
and using optimistic locking to ensure concurrence when multiple user attempt to change quantity of one product at the same time.
=end
	def save_order
	    product = Product.find @product_id
	    product_quantity = product[:quantity]
	    signal = false
	    quantity_runout = false
	    Order.transaction do
	      self.save!
	      logger.info "Order : "+ self.id.to_s+" is successfully created"
	      until quantity_runout do
	        begin
	          decrease_correspoding_product
	        rescue ActiveRecord::StaleObjectError
	          quantity_runout = true unless product_quantity >= @amount
	          next
	        else
	          signal = true
	          break
	        end
	      end 
	    end
	    logger.info "Product : " + @product_id.to_s + "'s quantity run out!" unless !quantity_runout
	    return signal
	end


	private :set_attributes
end
