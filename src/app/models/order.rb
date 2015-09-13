class Order < ActiveRecord::Base
	has_many :order_products

	def initialize attributes = nil
		if attributes
			amount = attributes["amount"]
			current_user_id = attributes["current_user_id"]
			product_id = attributes["product_id"]
			excludes = [ "current_user_id" ,"product_id", "amount"]
			attributes.except!( *excludes )
		end
		super attributes
		set_attributes amount, product_id, current_user_id unless attributes == nil
	end

	def set_attributes amount, product_id, current_user_id
		product = Product.find product_id
		total_price = amount.to_d * product.price.to_d
   		attributes = {buyer_id: current_user_id, seller_id: product.seller_id, status: "unpaid", total_price: total_price}
   		self.attributes = attributes
   		attrs = {product_id: product_id, quantity: amount}
   		order_product = OrderProduct.new attrs
   		self.order_products << order_product
	end
end
