class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
    can :search, Search
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :index, User
    can :me, User, id: user.id

    alias_action :create, :read, :update, :destroy, to: :crud
    can :crud, [Question, Answer], user: user
    can :create, Comment

    can :manage, Attachment do |attachment|
      user.is_owner_of?(attachment.attachable)
    end

    can :best, Answer do |answer|
      user.is_owner_of?(answer.question) && !user.is_owner_of?(answer)
    end

    can :create, Vote do |vote|
      !(user.is_owner_of?(vote.votable))
    end

    can :destroy, Vote, user: user

    can [:create, :destroy], Subscription, user: user
  end
end
