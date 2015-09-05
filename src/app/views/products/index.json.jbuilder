json.array!(@products) do |product|
  json.extract! product, :id, :seller_id, :name, :quantity, :price, :description, :actable_id, :actable_type
  json.url product_url(product, format: :json)
end
