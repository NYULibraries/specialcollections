FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "test123#{n}"} 
    sequence(:email) { |n| "test123#{n}@library.edu" }
  end
end