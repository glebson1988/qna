require 'rails_helper'

shared_examples_for 'is_linkable' do
  it { should have_many(:links).dependent(:destroy) }
  it { should accept_nested_attributes_for :links }
end
