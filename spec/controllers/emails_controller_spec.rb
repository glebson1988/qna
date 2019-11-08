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
    before { post :create, params: { email: user.email } }

    it 'redirects to login page' do
      expect(response).to redirect_to new_user_session_path
    end
  end
end