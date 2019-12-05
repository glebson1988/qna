require 'rails_helper'

RSpec.describe ReputationJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { build(:question, user: user) }

  it 'calls Services::Reputation#call' do
    expect(Services::Reputation).to receive(:call).with(question)
    ReputationJob.perform_now(question)
  end
end
