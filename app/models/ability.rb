class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new(id: -1)

    can :manage, Project, user_id: user.id
    can :read, Project, private: false
    can :create, Project
    can :share, Project

    can :manage, Page, project: { user_id: user.id }
    can :read, Page, project: { private: false }

    can :manage, Crit, page: { project: { user_id: user.id } }

    can :create, Crit, page: { project: { private: false } }
    can :manage, Crit, user_id: user.id
  end
end
