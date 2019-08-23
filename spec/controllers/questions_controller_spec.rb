require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }


  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    before { login(user) }
    before { get :show, params: {id: question} }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves the new question in database' do
        expect { post :create, params: {question: attributes_for(:question)} }.to change(Question, :count).by(1)
      end

      it 'created by current user' do
        post :create, params: {question: attributes_for(:question)}
        expect(assigns(:question).user_id).to eq(question.user_id)
      end

      it 'redirects to show view' do
        post :create, params: {question: attributes_for(:question)}
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: {question: attributes_for(:question, :invalid)} }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: {question: attributes_for(:question, :invalid)}
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: user) }

    context 'User is author' do
      before { login(user) }


      it 'checks that question was deleted' do
        delete :destroy, params: {id: question}
        expect(assigns(:question)).to be_destroyed
      end

      it 'redirects to questions list' do
        delete :destroy, params: {id: question}
        expect(response).to redirect_to questions_path
      end
    end

    context 'User is not an author' do
      let(:other_user) { create(:user) }
      before { login(other_user) }

      it 'tries to delete question' do
        expect { delete :destroy, params: {id: question} }.to_not change(Question, :count)
      end

      it 'redirects to questions list' do
        delete :destroy, params: {id: question}
        expect(response).to redirect_to questions_path
      end
    end

    context 'Unauthorized user' do
      it 'tries to delete question' do
        expect { delete :destroy, params: {id: question} }.to_not change(Question, :count)
      end

      it 'redirects to login page' do
        delete :destroy, params: {id: question}
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    let!(:question) { create(:question, user: user) }

    context 'with valid attributes' do
      before { login(user) }

      it 'changes question attributes' do
        patch :update, params: {id: question, question: {title: 'new question title', body: 'new question body'}}, format: :js
        question.reload
        expect(question.title).to eq 'new question title'
        expect(question.body).to eq 'new question body'
      end

      it 'renders update view' do
        patch :update, params: {id: question, question: {title: 'new question title', body: 'new question body'}}, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not change question attributes' do
        patch :update, params: {id: question, question: attributes_for(:question, :invalid)}, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'renders update view' do
        patch :update, params: {id: question, question: attributes_for(:question, :invalid)}, format: :js
        expect(response).to render_template :update
      end
    end

    context 'Not an author' do
      let(:not_author) { create(:user) }
      before { login(:not_author) }

      it 'tries do edit question' do
        patch :update, params: {id: question, question: {title: 'new question title', body: 'new question body'}}, format: :js
        question.reload
        expect(question.title).to_not eq 'new question title'
        expect(question.body).to_not eq 'new question body'
      end
    end

    context 'Unauthorized user' do
      it 'tries to edit question' do
        patch :update, params: {id: question, question: {title: 'new question title', body: 'new question body'}}, format: :js
        question.reload
        expect(question.title).to_not eq 'new question title'
        expect(question.body).to_not eq 'new question body'
      end
    end
  end

end
