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
end