FactoryGirl.define do
  factory :user do
    email 'user@test.com'
    password '12345678'
    password_confirmation '12345678'
    is_admin false

    factory :admin do
      email 'admin@test.com'
      password 'topsecret'
      password_confirmation 'topsecret'
      is_admin true
    end
  end   

  factory :category do
    name 'Смарфтоны'
    description 'Телефоны с большим сенсорным экраном'    

    factory :main_category do
      name 'Электроника'
      description 'Всякая разная'
    end

    factory :sub_category do
      name 'Android'
      description 'Телефоны с Android'    
    end

    factory :new_category do
      name 'КПК'
      description 'Карманые компьютеры'    
    end
  end  

  factory :image do
    source File.open(File.join(Rails.root, 'spec/support/images/another image.jpg'))

    factory :new_image do
      source File.open(File.join(Rails.root, 'spec/support/images/tiger.jpg'))
    end
  end

  factory :product do
    name 'Телефон Nexus 4'
    description 'Всегда последняя версия Android'
    shop_price 9999.99    
    before(:create) do |product|
      FactoryGirl.create_list(:image, 1, imageable: product)
    end
  end

  factory :new_product, class: Product do
    name 'iPhone 5U'
    description 'Новый мега-смартфон'
    shop_price 18888.88    
  end  

  factory :auction do    
    start_price 199.78
    start_time Time.new + 10.minutes
    min_price 8990.10
    duration 567
    bid_time_step 120
    bid_price_step 20.5    
    product
    before(:create) do |auction|
      auction.image = auction.product.images.first
    end
  end  
end