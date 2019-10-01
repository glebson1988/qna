require 'rails_helper'

RSpec.describe Link, type: :model  do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  let(:valid_link) { create(:link, :valid_gist, :linkable)}
  let(:invalid_link) { create(:link, :invalid_gist, :linkable) }
  let(:link) { create :link, :linkable }

  describe '#gist_id' do
    it 'returns id for gist link' do
      expect(valid_link.send(:gist_id)).to eq 'f98759463ccbd9ebc42ea503c80ffa34'
    end

    it 'returns nil for not gist link' do
      expect(invalid_link.send(:gist_id)).to be_nil
    end
  end

  describe '#gist?' do
    it 'valid' do
      expect(valid_link).to be_gist
    end

    it 'invalid' do
      expect(invalid_link).to_not be_gist
    end
  end

  describe '#gist_content', :vcr  do
    it 'gets content' do
      expect(valid_link.gist_content).to eq 'qnatest'
    end

    it 'returns false for not gist link' do
      expect(link.gist_content).to be_falsey
    end
  end
end
