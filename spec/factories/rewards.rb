FactoryBot.define do
  factory :reward do
    title { "MyReward" }
    image { fixture_file_upload("#{Rails.root}/app/assets/images/reward.png")}
    association :question, factory: :question
  end
end
