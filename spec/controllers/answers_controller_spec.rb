require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'GET #new' do
    before { login(user) }

    before { get :new, params: {question_id: question} }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    before { login(user) }

    before { get :show, params: {id: answer} }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer to database' do
        expect { post :create, params: {answer: attributes_for(:answer), question_id: question}, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'created by current user' do
        post :create, params: {question_id: question, answer: attributes_for(:answer), format: :js}
        expect(assigns(:answer).user_id).to eq(answer.user_id)
      end

      it 'renders create template' do
        post :create, params: {question_id: question, answer: attributes_for(:answer), format: :js}
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid), format: :js} }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid), format: :js}
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'User is author' do
      before { login(user) }

      it 'check that answer was deleted' do
        delete :destroy, params: {id: answer}, format: :js
        expect(assigns(:answer)).to be_destroyed
      end

      it 'renders destroy view' do
        delete :destroy, params: {id: answer}, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User is not author' do
      let(:other_user) { create(:user) }
      before { login(other_user) }

      it 'tries to delete answer' do
        expect { delete :destroy, params: {id: answer}, format: :js }.to_not change(Answer, :count)
      end

      it 'get empty response' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response.body).to be_empty
      end
    end

    context 'Unauthorized user' do
      it 'tries to delete answer' do
        expect { delete :destroy, params: {id: answer}, format: :js }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: {id: answer, answer: {body: 'new body'}}, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: {id: answer, answer: {body: 'new body'}}, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: {id: answer, answer: attributes_for(:answer, :invalid)}, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: {id: answer, answer: attributes_for(:answer, :invalid)}, format: :js
        expect(response).to render_template :update
      end
    end
  end
end
