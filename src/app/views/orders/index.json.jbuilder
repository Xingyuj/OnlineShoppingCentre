json.array!(@orders) do |order|
  json.extract! order, :id, :buyer_id, :seller_id, :status, :total_price, :postcode, :address, :phone
  json.url order_url(order, format: :json)
end
