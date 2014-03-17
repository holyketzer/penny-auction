class Admin::UsersController < Admin::BaseController
  respond_to :html, only: [:index, :show]
end