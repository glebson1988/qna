require 'rails_helper'

feature 'User can add reward to question', %q{
  In order to reward author of the best answer
  As an question's author
  I'd like to be able to set a reward
} do

  given(:author) { create(:user) }

  background do
    sign_in author
    visit new_question_path
  end

  scenario 'Author of question adds reward when asks question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    within '.reward' do
      fill_in 'Reward title', with: 'My Reward'
      attach_file 'Image', "#{Rails.root}/app/assets/images/reward.png"
    end

    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created with reward'
  end
end
