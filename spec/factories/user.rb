FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "test123#{n}"}
    sequence(:email) { |n| "test123#{n}@library.edu" }
    firstname "Ptolemy"
  end

  factory :user_dev, class: User do
    firstname "Ramses"
  	username "dev123"
  	email    "dev.loper@library.edu"
  end
end
