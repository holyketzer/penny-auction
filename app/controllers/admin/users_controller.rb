class Admin::UsersController < Admin::BaseController
  respond_to :html, only: [:index, :show, :new, :create, :edit, :update]

  def create
    @user.role = Role.bot
    password = Devise.friendly_token[0, 20]
    @user.password = password
    @user.password_confirmation = password
    create!
  end

  def edit
    if @user == current_user
      redirect_to admin_users_path, flash: { error: t('messages.cant_change_role') }
    else
      super
    end
  end

  def build_resource_params
    [params.fetch(:user, {}).permit(:role_id, :email, :nickname)]
  end
end