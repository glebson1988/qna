require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:another_question) { create(:question, user: another_user) }
  let!(:subscription) { create(:subscription, question: another_question, user: another_user) }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(user) }

      it 'saves a new question subscription in database' do
        expect { post :create, params: { question_id: question, format: :js } }.to change(question.subscriptions, :count).by(1)
      end

      it 'assigns subscription to current user' do
        post :create, params: { question_id: question, format: :js }
        expect(assigns(:subscription).user).to eq user
      end
    end

    context 'non-authenticated user' do
      it 'does not save the subscription' do
        expect { post :create, params: { question_id: question, format: :js } }.to_not change(question.subscriptions, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authenticated user' do
      before { login(another_user) }

      it 'deletes question subscription from database' do
        expect { delete :destroy, params: { id: subscription, format: :js } }.to change(another_question.subscriptions, :count).by(-1)
      end
    end

    context 'another authenticated user' do
      before { login(user) }

      it "tries to delete another's user subscription" do
        expect { delete :destroy, params: { id: subscription, format: :js } }.to raise_exception ActiveRecord::RecordNotFound
      end
    end

    context 'non-authenticated user' do
      it 'does not delete the subscription' do
        expect { delete :destroy, params: { id: subscription, format: :js } }.to_not change(question.subscriptions, :count)
      end
    end
  end
end
