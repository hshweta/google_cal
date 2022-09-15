class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    # for Google OmniAuth
    :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :events

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

  # retrieve the access token and refresh if necessary
  def token
    refresh! if true #access_token_expired?
    access_token
  end

  def events_by_calendar(calenar_id)
    events.by_calendar(calenar_id)
  end

  private

  def access_token_expired?
    expires_at && expires_at < Time.current.to_i
  end

  def refresh!
    data = JSON.parse(request_token_from_google.body)
    update(
      access_token: data['access_token'],
      expires_at: Time.now + data['expires_in'].to_i.seconds
    )
  end

  def request_token_from_google
    url = URI(ENV['GOOGLE_OAUTH_TOKEN_URL'])
    Net::HTTP.post_form(url, self.to_params)
  end

  def to_params
    { 'refresh_token' => refresh_token,
      'client_id'     => ENV['GOOGLE_OAUTH_CLIENT_ID'],
      'client_secret' => ENV['GOOGLE_OAUTH_CLIENT_SECRET'],
      'grant_type'    => 'refresh_token'}
  end
end
