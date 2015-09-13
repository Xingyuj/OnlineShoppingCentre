class Product < ActiveRecord::Base
	actable

	#search products
	def self.search(search,page)
		if search
			order('title').where('title LIKE ?', "%#{search}%").paginate(page: page, per_page: 1)
		else
			order('title').all.paginate(page: page, per_page: 1)
		end
	end
end
