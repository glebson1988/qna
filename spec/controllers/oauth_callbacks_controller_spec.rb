require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Github' do
    let(:oauth_data) { mock_auth_hash(:github, 'new@user.com') }
    before { @request.env['omniauth.auth'] = mock_auth_hash(:github, 'new@user.com') }

    context 'user exist' do
      let(:user) { Services::FindForOauth.call(oauth_data) }

      before do
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
        get :github
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'has no user email' do
      before { @request.env['omniauth.auth'] = mock_auth_hash(:github, email: nil) }

      it 'redirects to submit email form' do
        get :github
        expect(response).to redirect_to user_set_email_path
      end
    end
  end

  describe 'Vkontakte' do
    let(:oauth_data) { mock_auth_hash(:vkontakte, 'new@user.com') }
    before { @request.env['omniauth.auth'] = mock_auth_hash(:vkontakte, 'new@user.com') }

    context 'user exist' do
      let(:user) { Services::FindForOauth.call(oauth_data) }

      before do
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
        get :vkontakte
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'has no user email' do
      before { @request.env['omniauth.auth'] = mock_auth_hash(:vkontakte, email: nil) }

      it 'redirects to submit email form' do
        get :vkontakte
        expect(response).to redirect_to user_set_email_path
      end
    end
  end
end
