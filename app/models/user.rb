class User < ActiveRecord::Base
  devise :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  has_many :projects
  has_many :crits

  def self.find_for_facebook_oauth(auth, guest_user)
    user = User.where(email: auth.info.email).first

    if user
      guest_user.projects.update_all(user_id: user.id)
      guest_user.delete
    else
      guest_user.update(name: auth.extra.raw_info.name, email: auth.info.email, provider: 'facebook')
      user = guest_user.becomes!(User)
      user.save!
    end

    user
  end

  def self.find_for_google_oauth2(access_token, guest_user)
    data = access_token.info
    user = User.where(email: data['email']).first

    if user
      guest_user.projects.update_all(user_id: user.id)
      guest_user.delete
    else
      guest_user.update(name: data['name'], email: data['email'], provider: 'google')
      user = guest_user.becomes!(User)
      user.save!
    end

    user
  end

  def recent_projects
    projects.limit(10)
  end
end
