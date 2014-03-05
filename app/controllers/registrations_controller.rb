class RegistrationsController < Devise::RegistrationsController
  def new
    @user = User.new
    @user.build_avatar
    auth = session['devise.oauth']

    if auth.present?
      @user.email = auth[:info][:email]
      @user.nickname = auth[:info][:nickname]
    end
  end

  def create
    auth = session['devise.oauth']
    super do |user|
      user.create_authorization(auth) if auth
      avatar_id = session['devise.avatar_id']
      if avatar_id
        avatar = Avatar.find(avatar_id)
        avatar.update!(user: user)
      end
    end
  end
end