class Admin::UsersController < Admin::BaseController
  respond_to :html, only: [:index, :show, :edit, :update]

  def build_resource_params
    [params.fetch(:user, {}).permit(:role)]
  end
end