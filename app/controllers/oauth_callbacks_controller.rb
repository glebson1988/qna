class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth('Github')
  end

  def vkontakte
    oauth('vkontakte')
  end

  def oauth(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
