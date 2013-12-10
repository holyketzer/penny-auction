json.array!(@products) do |product|
  json.extract! product, :name, :description, :shop_price
  json.url product_url(product, format: :json)
end
