FactoryGirl.define do
  sequence(:username) { |n| "mtwtfss#{n}" }

  factory :user do
    username { generate :username }
    password 'password'
    password_confirmation 'password'
    created_at Time.now
    updated_at Time.now
  end
end
