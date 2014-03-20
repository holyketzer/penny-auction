class Admin::RolesController < Admin::BaseController
  respond_to :html, only: [:index, :show, :edit, :update]
end