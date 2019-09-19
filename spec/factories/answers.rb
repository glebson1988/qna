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

    trait :with_attachment do
      after :create do |answer|
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"),
                            filename: 'rails_helper.rb')

        def answer.filename
          files[0].filename.to_s
        end
      end
    end
  end
end
