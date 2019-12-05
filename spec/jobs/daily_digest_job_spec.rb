require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
 it 'calls Services::DailyDigest#call' do
    expect(Services::DailyDigest).to receive(:call)
    DailyDigestJob.perform_now
  end
end
