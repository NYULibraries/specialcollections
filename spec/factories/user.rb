FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "test123#{n}"} 
    sequence(:email) { |n| "test123#{n}@library.edu" }
  end

  factory :user_dev, class:User do
  	username "dev123"
  	email    "dev.loper@library.edu"
  end
end
