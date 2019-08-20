FactoryBot.define do
  sequence(:answer_body) { |n| "Answer#{n}" }

  factory :answer do
    body { generate(:answer_body) }
    question
    user

    trait :invalid do
      body { nil }
      question
      user
    end
  end
end
