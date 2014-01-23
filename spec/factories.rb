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

  factory :new_category, class: Category do
    name 'КПК'
    description 'Карманые компьютеры'
  end

  factory :product do
    name 'Телефон Nexus 4'
    description 'Всегда последняяверсия Android'
    shop_price 9999.99
    category
  end

  factory :new_product, class: Product do
    name 'iPhone 5U'
    description 'Новый мега-смартфон'
    shop_price 18888.88    
    association :category, factory: :new_category
  end
end