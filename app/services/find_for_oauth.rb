class Services::FindForOauth

  def call(auth)
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.find_by(email: email)

    if user
      User.transaction do
        user.update!(confirmed_at: Time.now)
        user.create_authorization!(auth)
      end
    else
      password = Devise.friendly_token[0, 20]
      User.transaction do
        user = User.create!(email: email, 
                            password: password,
                            password_confirmation: password,
                            confirmed_at: Time.now)
        user.create_authorization!(auth)
      end
    end
    user
  end
  
end
