FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@test.com" }
    password '12345678'
    password_confirmation '12345678'
    sequence(:nickname) { |n| "user#{n}" }

    factory :admin do
      sequence(:email) { |n| "admin-#{n}@test.com" }
      password 'topsecret'
      password_confirmation 'topsecret'
      role 'admin'
    end

    factory :manager do
      sequence(:email) { |n| "manager-#{n}@test.com" }
      role 'manager'
    end

    trait :with_avatar do
      avatar
    end
  end

  factory :avatar do
    source File.open(File.join(Rails.root, 'spec/support/images/tiger.jpg'))

    factory :new_avatar do
      source File.open(File.join(Rails.root, 'spec/support/images/another image.jpg'))
    end
  end

  factory :authorization do
    provider 'facebook'
    sequence(:uid) { |n| n+1000 }
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
    start_time Time.now + 10.minutes
    min_price 8990.10
    duration 567
    bid_time_step 120
    bid_price_step 20.5
    product
    before(:create) do |auction|
      auction.image = auction.product.images.first
    end

    trait :not_started do
    end

    trait :active do
      start_time Time.now - 10.minutes
      duration 25.minutes
    end

    trait :finished do
      start_time Time.now - 30.minutes
      duration 5.minutes
    end
  end

  factory :bid do
    user
    # initialize_with { attributes[:auction].make_bid(attributes[:user]) }
  end
end