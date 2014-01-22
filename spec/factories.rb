FactoryGirl.define do
  factory :user do
    email 'user@test.com'
    password '12345678'
    password_confirmation '12345678'
    is_admin false
  end

  factory :admin, class: User do
    email 'admin@test.com'
    password 'topsecret'
    password_confirmation 'topsecret'
    is_admin true
  end

  factory :category do
    name 'Смарфтоны'
    description 'Телефоны с большим сенсорным экраном'
  end

  factory :product do
    name 'Телефон Nexus 4'
    description 'Всегда последняяверсия Android'
    shop_price 9999.99
    category
  end
end