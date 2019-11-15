class OauthCallbacksController < Devise::OmniauthCallbacksController
  
  def github
    oauth('github')
  end

  def vkontakte
    oauth('vkontakte')
  end

  def oauth(provider)
    unless request.env['omniauth.auth'].info[:email]
      redirect_to user_set_email_path
      return
    end

    @user = Services::FindForOauth.call(request.env['omniauth.auth'])

    if @user&.confirmed?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
