FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "bigPharaoh#{n}"}
    sequence(:email) { |n| "bigPharaoh#{n}@library.edu" }
    firstname "Ptolemy"
  end

  factory :user_dev, class: User do
    firstname "Ramses"
    username "hardenedheart4life"
    email "hardenedheart4life@library.edu"
  end
end
