class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  def self.find_for_oauth(auth)
    Services::FindForOauth.call(auth)
  end

  def create_authorization!(auth)
    self.authorizations.create!(provider: auth.provider, uid: auth.uid)
  end

  def author_of?(item)
    id == item.user_id
  end
end
