class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def edit
    redirect_to edit_user_registration_path
  end
end