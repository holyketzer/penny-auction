class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do
    # status: 403
    if signed_in?
      redirect_to :root, alert: t('devise.failure.unauthorized')
    else
      session[:return_to] = request.path
      redirect_to new_user_session_path, alert: t('devise.failure.unauthenticated')
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :nickname  << { avatar_attributes: [:source] }

    devise_parameter_sanitizer.for(:account_update) << :nickname  << { avatar_attributes: [:id, :source] }
  end
end
