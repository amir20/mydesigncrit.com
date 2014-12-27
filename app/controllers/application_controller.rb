class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery
  before_action :detect_device_variant

  def create_guest_user_if_needed
    user = current_user
    unless user
      user = AnonymousUser.create_guest
      sign_in(:user, user)
    end
    user
  end

  protected

  def detect_device_variant
    case request.user_agent
    when /MSIE 8.0/i
      request.variant = :unsupported
    when /iPhone/i
      request.variant = :phone
    end
  end
end
