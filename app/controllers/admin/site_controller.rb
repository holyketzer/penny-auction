class Admin::SiteController < ApplicationController
  before_action { authorize! :read, :admin_panel }

  layout 'admin'

  def index
  end
end
