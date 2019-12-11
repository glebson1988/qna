require 'rails_helper'

RSpec.describe Services::Search do
  Services::Search::SCOPES.each do |scope|
    it "calls search from #{scope}" do
      expect(scope.classify.constantize).to receive(:search).with('test')
      Services::Search.call(query: 'test', scope: scope)
    end
  end

  it 'not exist scope' do
    expect(Services::Search.call(query: 'test', scope: 'NotExist')).to be_nil
  end
end
