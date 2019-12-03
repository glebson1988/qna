require 'rails_helper'

RSpec.describe Services::NewAnswerNotification do
  let(:users) { create_list(:user, 2) }
  let(:question) { create(:question, user: users.first) }
  let(:answer) { create(:answer, question: question) }
  let!(:subscr_first) { create(:subscription, question: question, user: users.first) }
  let!(:subscr_last) { create(:subscription, question: question, user: users.last) }

  it 'sends notification about new answer' do
    Subscription.find_each do |subscription|
      expect(NewAnswerMailer).to receive(:new_notification).with(subscription.user, answer).and_call_original
    end

    Services::NewAnswerNotification.call(answer)
  end
end
