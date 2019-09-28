require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:question_reward) { create(:reward, question: question) }
  let(:reward) { create(:reward, user: user) }
  let(:another_user) { create(:user) }

  describe 'GET #index' do
    context 'Rewarded user' do
      before { login(user) }
      before { get :index }

      it 'renders index view' do
        expect(response).to render_template :index
      end

      it 'populates an array of rewards' do
        expect(assigns(:rewards)).to eq([reward])
      end
    end

    context 'Not rewarded user' do
      before { login(another_user) }
      before { get :index }

      it 'populates an array of rewards' do
        expect(assigns(:rewards)).to be_empty
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context 'Unauthorized user' do
      before { get :index }

      it 'populates an array of rewards' do
        expect(assigns(:rewards)).to eq nil
      end
    end
  end
end
