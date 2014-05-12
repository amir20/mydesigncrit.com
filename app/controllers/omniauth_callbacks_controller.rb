class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action { create_guest_user_if_needed }

  def facebook
    @user = User.find_for_facebook_oauth(request.env['omniauth.auth'], current_user)
    flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', :kind => 'Facebook'
    sign_in_and_redirect @user, :event => :authentication
  end

  def google_oauth2
    @user = User.find_for_google_oauth2(request.env['omniauth.auth'], current_user)
    flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', :kind => 'Google'
    sign_in_and_redirect @user, :event => :authentication
  end
end
