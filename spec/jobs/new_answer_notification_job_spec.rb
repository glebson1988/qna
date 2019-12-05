require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:question) { create(:question) }

  it 'calls Services::NewAnswerNotification#call' do
    expect(Services::NewAnswerNotification).to receive(:call)
    NewAnswerNotificationJob.perform_now(question)
  end
end
