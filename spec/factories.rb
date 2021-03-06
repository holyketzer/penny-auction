FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@test.com" }
    password '12345678'
    password_confirmation '12345678'
    sequence(:nickname) { |n| "user#{n}" }
    role { Role.find_by(name: 'user') }

    factory :admin do
      sequence(:email) { |n| "admin-#{n}@test.com" }
      password 'topsecret'
      password_confirmation 'topsecret'
      role { Role.find_by(name: 'admin') }
    end

    factory :manager do
      sequence(:email) { |n| "manager-#{n}@test.com" }
      role { Role.find_by(name: 'manager') }
    end

    factory :bot do
      sequence(:email) { |n| "bot-#{n}@test.com" }
      role { Role.find_by(name: 'bot') }
    end

    factory :locked_bot do
      sequence(:email) { |n| "locked_bot-#{n}@test.com" }
      role { Role.find_by(name: 'locked_bot') }
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
    sequence(:name) { |n| "Техника-№#{n}" }
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
    sequence(:name) { |n| "Телефон Nexus #{n}" }
    description 'Всегда последняя версия Android'
    shop_price 9999.99
    category
    before(:create) do |product|
      FactoryGirl.create_list(:image, 1, imageable: product)
    end
  end

  factory :new_product, class: Product do
    name 'iPhone 5U'
    description 'Новый мега-смартфон'
    shop_price 18888.88
    category
  end

  factory :auction do
    start_price 199.78
    start_time Time.now + 10.minutes
    min_price 8760.15
    duration 567
    bid_time_step 120
    bid_price_step 20.55
    product

    ignore do
      finish_time nil
    end

    before(:create) do |auction, evaluator|
      auction.image = auction.product.images.first
      if evaluator.finish_time
        auction.start_time = evaluator.finish_time - auction.duration.seconds
      end
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