class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    # for Google OmniAuth
    :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.try(:info).try(:email)
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.try(:info).try(:first_name)
      user.last_name = auth.try(:info).try(:last_name)
      user.access_token = auth.credentials.token
      user.expires_at = auth.credentials.expires_at
      user.refresh_token = auth.credentials.refresh_token
    end
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end
end
