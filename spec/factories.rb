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

  factory :main_category, class: Category do
    name 'Электроника'
    description 'Всякая разная'
  end

  factory :category do
    name 'Смарфтоны'
    description 'Телефоны с большим сенсорным экраном'
    #association :parent, factory: :main_category
  end

  factory :sub_category, class: Category do
    name 'Android'
    description 'Телефоны с Android'
    association :parent, factory: :category
  end

  factory :new_category, class: Category do
    name 'КПК'
    description 'Карманые компьютеры'
    association :parent, factory: :main_category
  end

  factory :product do
    name 'Телефон Nexus 4'
    description 'Всегда последняя версия Android'
    shop_price 9999.99
    category
  end

  factory :new_product, class: Product do
    name 'iPhone 5U'
    description 'Новый мега-смартфон'
    shop_price 18888.88    
    association :category, factory: :new_category
  end

  factory :auction do
    association :product
    start_price 199.78
    min_price 8999.78 
    duration 567
    bid_time_step 120
    bid_price_step 20.5
  end
end