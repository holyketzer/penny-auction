class RegistrationsController < Devise::RegistrationsController
  def new
    @user = User.new
    auth = session['devise.oauth']

    if auth.present?
      @user.email = auth[:info][:email]
      @user.nickname = auth[:info][:nickname]
    end
  end
end