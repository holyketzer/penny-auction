class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :oauth_callback

  def facebook
  end

  def vkontakte
  end

  def oauth_callback
    auth = request.env['omniauth.auth']
    provider = auth[:provider].capitalize

    if signed_in?
      if current_user.add_authorization(auth)
        flash[:notice] = t('devise.omniauth_callbacks.associated', provider: provider)
      else
        flash[:error] = t('devise.omniauth_callbacks.not_associated', provider: provider)
      end
      redirect_to profile_path
    else
      @user = User.find_for_oauth(auth)
      avatar = Avatar.create(remote_source_url: process_uri(auth.info[:image]))
      if @user && @user.persisted?
        avatar.update!(user: @user) if avatar.source
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
      else
        flash[:notice] = t('registration.new.finish')
        session['devise.oauth'] = auth
        session['devise.avatar_id'] = avatar.id if avatar.source
        redirect_to new_user_registration_path
      end
    end
  end

  private

  def process_uri(uri)
    if uri
      require 'open-uri'
      require 'open_uri_redirections'
      open(uri, allow_redirections: :safe) do |r|
        r.base_uri.to_s
      end
    end
  end
end
