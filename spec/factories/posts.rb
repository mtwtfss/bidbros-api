FactoryGirl.define do
  factory :post do
    association :user
    title 'Google'
    url 'https://www.google.com/'
    created_at Time.now
    updated_at Time.now
  end
end
