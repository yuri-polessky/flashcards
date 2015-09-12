FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "user#{n}@gmail.com" }
    password "pass"
    password_confirmation "pass"
    locale "ru"
  end

end