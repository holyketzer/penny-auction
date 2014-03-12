class Admin::BaseController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :authorize_resource

  layout 'admin'

  protected

  def authorize_resource
     authorize! :manage, :admin
  end
end