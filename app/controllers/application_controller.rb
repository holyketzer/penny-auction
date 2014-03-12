class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do
    redirect_to :root, alert: t('devise.failure.unauthorized') #, status: 403
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :nickname  << { avatar_attributes: [:source] }

    devise_parameter_sanitizer.for(:account_update) << :nickname  << { avatar_attributes: [:id, :source] }
  end
end
