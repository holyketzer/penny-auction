class Admin::UsersController < Admin::BaseController
  respond_to :html, only: [:index, :show, :edit, :update]

  def edit
    if @user == current_user
      redirect_to admin_users_path, flash: { error: t('messages.cant_change_role') }
    else
      super
    end
  end

  def build_resource_params
    [params.fetch(:user, {}).permit(:role)]
  end
end