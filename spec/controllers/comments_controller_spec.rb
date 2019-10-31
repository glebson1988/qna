require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    context 'Authorized user creates comment with valid attributes' do
      before { login(user) }

      it 'saves a new comment to database' do
        expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :json }.to change(Comment, :count).by 1
      end

      it 'created by current user' do
        post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :json

        expect(assigns(:comment).user).to eq user
      end

      it 'returns data in json' do
        post :create, params: { comment: attributes_for(:comment),
                                question_id: question }, format: :json

        expect(JSON.parse(response.body).keys).to eq %w(id body user_id commentable_type commentable_id created_at updated_at)
      end
    end

    context 'Authorized user creates comment with invalid attributes' do
      before { login(user) }

      it 'does not save the comment' do
        expect { post :create, params: {comment: attributes_for(:comment, :invalid), question_id: question, format: :json} }.to_not change(Comment, :count)
      end

      it 'returns error response' do
        post :create, params: {comment: attributes_for(:comment, :invalid), question_id: question, format: :json}

        expect(response.status).to eq 422
      end
    end

    context 'Unauthorized user' do
      it 'tries to save a new comment to database' do
        expect { post :create, params: { comment: attributes_for(:comment),
                                         question_id: question }, format: :json }.to_not change(Comment, :count)
      end
    end
  end
end
