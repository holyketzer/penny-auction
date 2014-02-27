class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :oauth_callback

  def facebook    
  end

  def vkontakte
  end

  def oauth_callback
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)

    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth[:provider].capitalize) if is_navigational_format?
    else 
      flash[:notice] = t('registration.new.finish')
      session['devise.oauth'] = auth
      redirect_to new_user_registration_path
    end
  end
end
