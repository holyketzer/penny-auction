class Admin::PermissionsController < Admin::BaseController
  belongs_to :role

  before_action :load_permissions, only: :index
  before_action :not_for_admin, only: :index

  def create
    permission = Permission.find(params[:permission_id])
    parent.permissions << permission
    redirect_to admin_role_permissions_path(role_id: parent)
  end

  def destroy
    role_permission = RolePermission.where(role: parent, permission_id: params[:id]).first
    role_permission.destroy if role_permission.present?
    redirect_to admin_role_permissions_path(role_id: parent)
  end

  private

  def load_permissions
    @all_permissions ||= Permission.all
  end

  def not_for_admin
    if parent.name == 'admin'
      redirect_to admin_roles_path, flash: { error: t('messages.cant_edit_admin_role') }
    end
  end
end