require 'rails_helper'

RSpec.describe GistService, :vcr do

  let(:valid_gist_id) { 'f98759463ccbd9ebc42ea503c80ffa34' }
  let(:invalid_gist_id) { '1234567890' }

  describe '#call method of GistService' do
    it 'returns content of gist with valid gist id' do
      expect(GistService.new(valid_gist_id).call).to eq 'qnatest'
    end

    it 'returns false with invalid gist id' do
      expect(GistService.new(invalid_gist_id).call).to eq false
    end
  end
end
