class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :create, Project
    can :read, Project
    can :destroy, Project, user_id: user.id
    can :update, Project, user_id: user.id

    can :manage, Page, project: { user_id: user.id }

    can :manage, Crit, user_id: user.id
    can :create, Crit, page: { project: { user_id: user.id } }
    can :create, Crit, page: { project: { private: false } }

  end
end
