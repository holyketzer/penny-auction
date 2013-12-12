json.array!(@categories) do |category|
  json.extract! category, :name, :description, :ancestry
  json.url category_url(category, format: :json)
end
