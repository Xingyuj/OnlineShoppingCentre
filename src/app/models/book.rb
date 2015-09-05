class Book < ActiveRecord::Base
	acts_as :product
	accepts_nested_attributes_for :product
end
