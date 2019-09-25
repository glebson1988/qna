require 'rails_helper'

RSpec.describe GistService, type: :service do
  let(:service_with_valid_gist_id) { GistService.new('f98759463ccbd9ebc42ea503c80ffa34') }
  let(:service_with_invalid_gist_id) { GistService.new('1234567890') }

  describe '#call method of GistService' do
    it 'returns content of gist with valid gist id' do
      expect(service_with_valid_gist_id.call).to eq 'qnatest'
    end

    it 'returns false with invalid gist id' do
      expect(service_with_invalid_gist_id.call).to eq false
    end
  end
end
