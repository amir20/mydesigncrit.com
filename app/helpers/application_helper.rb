module ApplicationHelper
  def anonymous_user?
    current_user.is_a? AnonymousUser
  end
end
