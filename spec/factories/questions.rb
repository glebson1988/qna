FactoryBot.define do
  sequence(:title) { |n| "Title#{n}" }
  sequence(:body) { |n| "Question#{n}" }

  factory :question do
    title
    body
    user

    trait :invalid do
      title { nil }
      body { nil }
    end
  end
end
