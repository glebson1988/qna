class Services::FindForOauth

  def self.call(auth)
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.find_by(email: email)

    if user
      user.confirm
    else
      password = Devise.friendly_token[0, 20]
      User.transaction do
        user = User.create!(email: email, 
                            password: password,
                            password_confirmation: password,
                            confirmed_at: Time.zone.now)
        user.create_authorization!(auth)
      end
    end
    user
  end
  
end
