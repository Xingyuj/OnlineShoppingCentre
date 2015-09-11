class Product < ActiveRecord::Base
	actable

	#search products
	def self.search(search,page)
		if search
			order('name').where('name LIKE ?', "%#{search}%").paginate(page: page, per_page: 1)
		else
			order('name').all.paginate(page: page, per_page: 1)
		end
	end
end
