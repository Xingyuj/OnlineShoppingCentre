class Product < ActiveRecord::Base
	actable
	has_many :images
	validates :quantity,
						:presence => true,
						:numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }


	#search products
	def self.search(search, page)
		if search
			order('title').where('title LIKE ?', "%#{search}%").paginate(page: page, per_page: 8)
		else
			order('title').all.paginate(page: page, per_page: 8)
		end
	end

	def self.category_products(type, category, page)
		if type && category
			@products = order("created_at DESC").where(actable_type: type, category: category).paginate(page: page, per_page: 8)
		elsif type
			@products = order("created_at DESC").where(actable_type: type).paginate(page: page, per_page: 8)
		end
		return @products
	end

end
