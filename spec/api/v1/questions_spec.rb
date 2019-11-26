require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {{"ACCEPT" => 'application/json'}}

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request successful'

      it_behaves_like 'Return list' do
        let(:resource_response) { json['questions'] }
        let(:resource) { questions } 
      end

      it_behaves_like 'Public fields' do
        let(:attrs) { %w[id title body created_at updated_at] }
        let(:resource_response) { question_response }
        let(:resource) { question }
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it_behaves_like 'Return list' do
          let(:resource_response) { question_response['answers'] }
          let(:resource) { answers } 
        end

        it_behaves_like 'Public fields' do
          let(:attrs) { %w[id body created_at updated_at] }
          let(:resource_response) { answer_response }
          let(:resource) { answer }
        end
      end
    end

    describe 'GET /api/v1/questions/:id' do
      let(:user) { create(:user) }
      let(:question) { create(:question, :with_attachment, user: user) }
      let(:question_response) { json['question'] }
      let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
      let!(:links) { create_list(:link, 3, linkable: question) }
      let(:access_token) { create(:access_token) }
      let(:api_path) { "/api/v1/questions/#{question.id}" }

      it_behaves_like 'API Authorizable' do
        let(:method) { :get }
        let(:api_path) { '/api/v1/questions' }
      end

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request successful'

      it_behaves_like 'Public fields' do
        let(:attrs) { %w[id title body created_at updated_at] }
        let(:resource_response) { question_response }
        let(:resource) { question }
      end

      describe 'comments' do
        it_behaves_like 'Return list' do
          let(:resource_response) { question_response['comments'] }
          let(:resource) { comments }
        end
      end

      describe 'links' do
        it_behaves_like 'Return list' do
          let(:resource_response) { question_response['links'] }
          let(:resource) { links }
        end
      end

      describe 'files' do
        it_behaves_like 'Return list' do
          let(:resource_response) { question_response['files'] }
          let(:resource) { question.files }
        end
      end
    end

    describe 'POST /api/v1/questions' do
      let(:api_path) { '/api/v1/questions' }

      it_behaves_like 'API Authorizable' do
        let(:method) { :post }
      end

      context 'authorized' do
        let(:user) { create(:user) }
        let(:access_token) { create(:access_token) }

        before { get api_path, params: {access_token: access_token.token}, headers: headers }

        context 'with valid attributes' do
          it 'saves a new question in database' do
            expect { post api_path, params: { question: attributes_for(:question),
                                              access_token:access_token.token } }.to change(Question, :count).by(1)
          end

          it 'returns status :created' do
            post api_path, params: { question: attributes_for(:question), access_token: access_token.token }
            expect(response.status).to eq 201
          end
        end

        context 'with invalid attributes' do
          it 'does not save the question' do
            expect { post api_path, params: { question: attributes_for(:question, :invalid),
                                              access_token: access_token.token } }.to_not change(Question, :count)
          end

          it 'returns status :unprocessible_entity' do
            post api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token }
            expect(response.status).to eq 422
          end

          it 'return error message' do
            post api_path, params: { question: attributes_for(:question, :invalid), access_token: access_token.token }
            expect(json['errors']).to be
          end
        end
      end
    end
  end
end
