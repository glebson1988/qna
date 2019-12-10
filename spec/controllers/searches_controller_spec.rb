require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #index' do

    let!(:questions) { create_list(:question, 3) }
    subject { Services::Search }

    context 'with valid attributes' do
      Services::Search::SCOPES.each do |scope|
        before do
          expect(subject).to receive(:call).and_return(questions)
          get :index, params: { query: questions.sample.title, scope: scope }
        end

        it "#{scope} returns 2xx status" do
          expect(response).to be_successful
        end

        it "renders #{scope} index view" do
          expect(response).to render_template :index
        end

        it "#{scope} assign Services::Search.call to @results" do
          expect(assigns(:results)).to eq questions
        end
      end
    end

    context 'with invalid attributes' do
      before do
        get :index, params: { query: questions.sample.title, scope: 'stub' }
      end

      it 'return status 400' do
        expect(response.status).to eq 400
      end
    end
  end
end
