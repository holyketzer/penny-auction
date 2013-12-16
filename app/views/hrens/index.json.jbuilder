json.array!(@hrens) do |hren|
  json.extract! hren, 
  json.url hren_url(hren, format: :json)
end
