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

    trait :with_reward do
      reward { create(:reward) }
    end

    trait :with_attachment do
      after :create do |question|
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"),
                            filename: 'rails_helper.rb')

        def question.filename
          files[0].filename.to_s
        end
      end
    end
  end
end
