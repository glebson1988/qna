require 'rails_helper'

shared_examples_for 'voted' do
  let(:model) { described_class.controller_name.classify.constantize }
  let(:votable) { create(model.to_s.underscore.to_sym) }
end
