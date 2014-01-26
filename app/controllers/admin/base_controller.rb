class Admin::BaseController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :check_admin

  layout 'admin'

  protected

  def check_admin
    redirect_to :root, notice: t('devise.failure.unauthorized') unless current_user.is_admin?
    false
  end
end