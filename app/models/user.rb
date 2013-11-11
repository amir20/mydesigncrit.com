class User < ActiveRecord::Base
  devise :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  has_many :projects

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(email: auth.info.email).first
    user = User.create(name: auth.extra.raw_info.name, email: auth.info.email) unless user
    user
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(email: data['email']).first
    user = User.create(name: data['name'], email: data['email']) unless user
    user
  end

end
