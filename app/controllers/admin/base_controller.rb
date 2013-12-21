class Admin::BaseController < ApplicationController
  layout 'admin'

  before_filter :authenticate_admin!

  private

  def authenticate_admin!    
    unless current_user && current_user.is_admin
      if current_user
        redirect_to :root, notice: "You haven't enough permissions"
      else
        redirect_to new_user_session_path, notice: "You should login"
      end
    end
  end
end