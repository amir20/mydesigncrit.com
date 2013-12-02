class User < ActiveRecord::Base
  devise :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  has_many :projects

  def self.find_for_facebook_oauth(auth, guest_user)
    user = User.where(email: auth.info.email).first

    # if user is already anonymous


    user = User.create(name: auth.extra.raw_info.name, email: auth.info.email, provider: 'facebook') unless user
    user
  end

  def self.find_for_google_oauth2(access_token, guest_user)
    data = access_token.info
    user = User.where(email: data['email']).first
    user = User.create(name: data['name'], email: data['email'], provider: 'google') unless user
    user
  end


  def recent_projects
    projects.order(created_at: :desc).limit(10)
  end
end
