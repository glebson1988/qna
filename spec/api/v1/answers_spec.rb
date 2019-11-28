require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) {{"ACCEPT" => 'application/json'}}

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question, user: user) }

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
      let!(:comments) { create_list(:comment, 2, commentable: answer, user: user) }
      let!(:links) { create_list(:link, 2, linkable: answer) }
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

  describe 'POST /api/v1/questions/:id/answers' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get api_path, params: {access_token: access_token.token}, headers: headers }

      it_behaves_like 'Request successful'

      context 'with valid attributes' do
        it 'saves a new answer in database' do
          expect { post api_path, params: { answer: attributes_for(:answer),
                                            access_token:access_token.token } }.to change(Answer, :count).by(1)
        end

        it 'returns status :created' do
          post api_path, params: { answer: attributes_for(:answer), access_token: access_token.token }
          expect(response.status).to eq 201
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post api_path, params: { answer: attributes_for(:answer, :invalid),
                                            access_token: access_token.token } }.to_not change(Question, :count)
        end

        it 'returns status :unprocessible_entity' do
          post api_path, params: { answer: attributes_for(:answer, :invalid), access_token: access_token.token }
          expect(response.status).to eq 422
        end

        it 'returns error message' do
          post api_path, params: { answer: attributes_for(:answer, :invalid), access_token: access_token.token }
          expect(json['errors']).to be
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      context 'with valid attributes' do
        before do
          patch api_path, params: { id: answer,
                                    answer: { body: 'new body' },
                                    access_token: access_token.token }
        end

        it_behaves_like 'Request successful'

        it 'changes question attributes' do
          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it 'returns status :created' do
          expect(response.status).to eq 201
        end
      end
    end

    context 'with invalid attributes' do
      before do
        patch api_path, params: { id: answer,
                                  answer: { body: '' },
                                  access_token: access_token.token }
      end

      it 'does not change attributes of answer' do
        answer.reload

        expect(answer.body).to_not eq 'new body'
      end

      it 'returns status :unprocessible_entity' do
        expect(response.status).to eq 422
      end

      it 'returns error message' do
        expect(json['errors']).to be
      end
    end

    context 'not an author tries to update answer' do
      let(:other_user) { create(:user) }
      let(:other_answer) { create(:answer, question: question, user: other_user) }
      let(:other_api_path) { "/api/v1/answers/#{other_answer.id}" }

      before do
        patch other_api_path, params: { id: other_answer,
                                        answer: { body: 'other_body' },
                                        access_token: access_token.token }
      end

      it 'returns status 302' do
        expect(response.status).to eq 302
      end

      it 'can not change answer attributes' do
        other_answer.reload

        expect(other_answer.body).to eq other_answer.body
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      context 'delete the answer' do
        let(:params) { { access_token: access_token.token,
                        answer_id: answer } }

        before { delete api_path, headers: headers, params: params }

        it_behaves_like 'Request successful'

        it 'delete the answer from the database' do
          expect(Answer.count).to eq 0
        end

        it 'returns json message' do
          expect(json['messages']).to include "Answer was successfully deleted."
        end
      end
    end

    context 'not an author' do
      let(:other_user) { create(:user) }
      let(:other_answer) { create(:answer, question: question, user: other_user) }
      let(:other_api_path) { "/api/v1/answers/#{other_answer.id}" }
      let(:params) { { access_token: access_token.token,
                       id: other_answer } }

      before { delete other_api_path, headers: headers, params: params }

      it 'returns status 403' do
        expect(response.status).to eq 403
      end

      it 'can not delete answer from the database' do
        expect(Answer.count).to eq 1
      end
    end
  end
end
