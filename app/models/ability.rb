class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.admin?
      admin_abilities
    elsif user
      user_abilities(user)
    else
      guest_abilities
    end
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities(user)
    user.permissions.each do |p|
      begin
        subject = p.subject.constantize
        if p.subject_id
          can p.action.to_sym, subject, id: p.subject_id
        else
          can p.action.to_sym, subject
        end
      rescue NameError
        can p.action.to_sym, p.subject.to_sym
      end
    end
  end

  def guest_abilities
    can :read, Auction
  end
end
