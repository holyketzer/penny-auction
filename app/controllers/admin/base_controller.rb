class Admin::BaseController < InheritedResources::Base
  before_action :authenticate_user!
  before_action { authorize! :read, :admin_panel }
  load_and_authorize_resource

  layout 'admin'
end