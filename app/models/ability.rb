class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.is_admin?
      admin_abilities
    elsif user
      user_abilities
    else
      guest_abilities
    end
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    can :read, Auction
    can :create, Bid
    can :manage, :profile
  end

  def guest_abilities
    can :read, Auction
  end
end
