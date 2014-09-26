class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :create, Project
    can :share, Project
    can :read, Project, user_id: user.id
    can :read, Project, private: false
    can :destroy, Project, user_id: user.id
    can :update, Project, user_id: user.id

    can :manage, Page, project: { user_id: user.id }
    can :read, Page, project: { private: false }

    can :manage, Crit, page: { project: { user_id: user.id } }

    if user.persisted? && !user.is_a?(AnonymousUser)
      can :manage, Crit, user_id: user.id
      can :create, Crit, page: { project: { private: false } }
    end
  end
end
