class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    return guest_abilities unless user

    user.admin? ? admin_abilities : user_abilities
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    can :index, User
    can :me, User, user: user

    can :create, [Question, Answer, Comment, Subscription]
    can :destroy, [Question, Answer, Subscription], user_id: user.id
    can :update, [Question, Answer], user_id: user.id

    can :destroy, ActiveStorage::Attachment do |file|
      user.author_of?(file.record)
    end

    can :destroy, Link, linkable: { user_id: user.id }

    can :set_best, Answer, question: { user_id: user.id }

    can %i[vote_up vote_down cancel_vote], [Answer, Question] do |votable|
      !user.author_of?(votable)
    end
  end
end
