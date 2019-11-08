require 'rails_helper'

RSpec.describe User::EmailsController, type: :controller do
  describe 'POST #set_email' do
    let(:user) { create(:user) }

    it 'redirects to log in page' do
      get :set_email, params: { email: user.email }

      expect(response).to redirect_to new_user_session_path
    end
  end
end