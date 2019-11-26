require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) {{"CONTENT_TYPE" => "application/json",
                  "ACCEPT" => 'application/json'}}

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 3, question: question, user: user) }

      before { get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request successful'

      it_behaves_like 'Return list' do
        let(:resource_response) { json['answers'] }
        let(:resource) { answers } 
      end

      it_behaves_like 'Public fields' do
        let(:attrs) { %w[id body created_at updated_at question_id user_id best] }
        let(:resource_response) { json['answers'].first }
        let(:resource) { answers.first }
      end
    end
  end

    describe 'GET /api/v1/answers/:id' do
      let(:user) { create(:user) }
      let(:question) { create(:question, :with_attachment, user: user) }
      let(:answer) { create(:answer, :with_attachment, question: question, user: user) }
      let(:answer_response) { json['answer'] }
      let!(:comments) { create_list(:comment, 3, commentable: answer, user: user) }
      let!(:links) { create_list(:link, 3, linkable: answer) }
      let(:access_token) { create(:access_token) }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }

      it_behaves_like 'API Authorizable' do
        let(:method) { :get }
        let(:api_path) { '/api/v1/questions' }
      end

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request successful'

      it_behaves_like 'Public fields' do
        let(:attrs) { %w[id body created_at updated_at] }
        let(:resource_response) { answer_response }
        let(:resource) { answer }
      end

      describe 'comments' do
        it_behaves_like 'Return list' do
          let(:resource_response) { answer_response['comments'] }
          let(:resource) { comments }
        end
      end

      describe 'links' do
        it_behaves_like 'Return list' do
          let(:resource_response) { answer_response['links'] }
          let(:resource) { links }
        end
      end

      describe 'files' do
        it_behaves_like 'Return list' do
          let(:resource_response) { answer_response['files'] }
          let(:resource) { answer.files }
      end
    end
  end
end
