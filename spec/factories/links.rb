FactoryBot.define do
  factory :link do
    name { "MyString" }

    trait :linkable do
      association :linkable, factory: :answer
    end

    trait :valid_gist do
      url { 'https://gist.github.com/glebson1988/f98759463ccbd9ebc42ea503c80ffa34' }
    end

    trait :invalid_gist do
      url { 'https://gist.github.com/glebson1988/' }
    end
  end
end
