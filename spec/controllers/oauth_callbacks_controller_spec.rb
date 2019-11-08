require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Github' do
    let(:oauth_data) { mock_auth_hash(:github, 'new@user.com') }
    before { @request.env['omniauth.auth'] = mock_auth_hash(:github, 'new@user.com') }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exist' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end

    context 'has no user email' do
      before { @request.env['omniauth.auth'] = mock_auth_hash(:github) }

      it 'redirects to submit email form' do
        get :github
        expect(response).to redirect_to user_set_email_path
      end
    end
  end

  describe 'Vkontakte' do
    let(:oauth_data) { mock_auth_hash(:vkontakte, 'new@user.com') }
    before { @request.env['omniauth.auth'] = mock_auth_hash(:vkontakte, 'new@user.com') }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :vkontakte
    end

    context 'user exist' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :vkontakte
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :vkontakte
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end

    context 'has no user email' do
      before { @request.env['omniauth.auth'] = mock_auth_hash(:vkontakte) }

      it 'redirects to submit email form' do
        get :vkontakte
        expect(response).to redirect_to user_set_email_path
      end
    end
  end
end
