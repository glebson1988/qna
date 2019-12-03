require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  it 'calls Services::NewAnswerNotification#call' do
    expect(Services::NewAnswerNotification).to receive(:call)
    NewAnswerNotificationJob.perform_now(question)
  end
end
