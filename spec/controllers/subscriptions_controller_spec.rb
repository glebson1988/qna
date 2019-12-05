require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    context 'authenticated user' do
      before { login(user) }

      it 'saves a new question subscription in database' do
        expect { post :create, params: { question_id: question, format: :js } }.to change(question.subscriptions, :count).by(1)
      end

      it 'assigns subscription to current user' do
        post :create, params: { question_id: question, format: :js }
        expect(assigns(:subscription).user).to eq user
      end

      it 'renders create view' do
        post :create, params: { question_id: question, format: :js }
        expect(response).to render_template :create
      end

      it 'returns 200 for authenticated user' do
        post :create, params: { question_id: question, format: :js }
        expect(response).to be_successful
      end
    end

    context 'non-authenticated user' do
      it 'does not save the subscription' do
        expect { post :create, params: { question_id: question, format: :js } }.to_not change(question.subscriptions, :count)
      end

      it 'returns 401 for not authenticated user' do
        post :create, params: { question_id: question, format: :js }

        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authenticated user' do
      let(:user) { create(:user) }
      let(:question) { create(:question) }
      let!(:subscription) { create(:subscription, question: question, user: user) }

      before { login(user) }

      it 'deletes question subscription from database' do
        expect { delete :destroy, params: { id: subscription, format: :js } }.to change(question.subscriptions, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: subscription, format: :js }
        expect(response).to render_template :destroy
      end

      it 'returns 200 for authenticated user' do
        delete :destroy, params: { id: subscription, format: :js }
        expect(response).to be_successful
      end
    end

    context 'another authenticated user' do
      let(:user) { create(:user) }
      let(:another_user) { create(:user) }
      let(:question) { create(:question) }
      let!(:subscription) { create(:subscription, question: question, user: user) }

      before { login(another_user) }

      it "tries to delete another's user subscription" do
        expect { delete :destroy, params: { id: subscription, format: :js } }.to raise_exception ActiveRecord::RecordNotFound
      end
    end

    context 'non-authenticated user' do
      let(:user) { create(:user) }
      let(:question) { create(:question) }
      let!(:subscription) { create(:subscription, question: question, user: user) }

      it 'does not delete the subscription' do
        expect { delete :destroy, params: { id: subscription, format: :js } }.to_not change(question.subscriptions, :count)
      end

      it 'returns 401 for not authenticated user' do
        delete :destroy, params: { id: subscription, format: :js }

        expect(response.status).to eq 401
      end
    end
  end
end
