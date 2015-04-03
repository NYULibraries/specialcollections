FactoryGirl.define do
  factory :user do
    username 'test123'
    sequence(:email) { |n| "test123#{n}@library.edu" }
  end
end