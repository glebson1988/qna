require 'rails_helper'

RSpec.describe User::EmailsController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #new' do
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do

    context 'with valid attributes' do
      it 'saves a new user in the database' do
        expect { post :create, params: { email: user.email } }.to change(User, :count).by(1)
      end

      it 'renders new view' do
        post :create, params: { email: user.email }
        expect(response).to render_template :new
      end
    end

    context 'with invalid attributes' do
      it 'renders new template' do
        post :create, params: { email: 'wrong_email' }
        expect(response).to render_template :new
      end

      it 'does not save new user in the database' do
        expect { post :create, params: { email: 'wrong_email' } }.to_not change(User, :count)
      end
    end
  end
end