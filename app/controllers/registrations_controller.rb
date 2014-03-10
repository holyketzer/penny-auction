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

  def show
    authenticate_scope!
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

  def update
    @user = User.find(current_user.id)

    # Don't update avatar if no image is presented
    params[:user].delete(:avatar_attributes) unless avatar_present?(params)

    successfully_updated = if needs_password?(@user, params)
      @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
    else
      # remove the virtual current_password attribute
      # update_without_password doesn't know how to ignore it
      params[:user].delete(:current_password)
      @user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
    end

    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to profile_path
    else
      render :edit
    end
  end

  private

  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  def needs_password?(user, params)
    user.email != params[:user][:email] ||
      params[:user][:password].present?
  end

  def avatar_present?(params)
    params[:user][:avatar_attributes] && params[:user][:avatar_attributes][:source]
  end
end