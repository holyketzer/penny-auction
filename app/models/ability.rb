class Ability
  include CanCan::Ability

  def initialize(user)
    role = user && user.role
    if role == 'admin'
      admin_abilities
    elsif role == 'manager'
      manager_abilities
    elsif role == 'user'
      user_abilities
    else
      guest_abilities
    end
  end

  def admin_abilities
    can :manage, :all
  end

  def manager_abilities
    user_abilities

    can :manage, Product
    can :manage, Category
    can :manage, Auction
    can :read, :admin_panel
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
