FactoryGirl.define do
  factory :user do
    sequence(:username) {|n| "bigPharaoh#{n}"}
    sequence(:email) { |n| "bigPharaoh#{n}@library.edu" }
    firstname "Ptolemy"
  end

  factory :user_dev, class: User do
    firstname "Ramses"
    sequence(:username) {|n| "hardenedheart4life#{n}"}
    sequence(:email) {|n| "hardenedheart4life#{n}@library.edu"}
  end
end
