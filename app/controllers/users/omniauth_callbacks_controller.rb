module Users
  # Public: This class is used for the omni auth callbacks
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    before_action :omniauth_user

    def google_oauth2
      sign_in_user
    end

    private

    # Internal: Signs in the user and redirects him to the correct url
    #
    # Returns nothing
    def sign_in_user
      if @user.persisted?
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success'
        sign_in_and_redirect @user, event: :authentication
      else
        session['devise.google_data'] = request.env['omniauth.auth']
        redirect_to new_user_registration_url
      end
    end

    def omniauth_user
      @user = User.from_omniauth(request.env['omniauth.auth'])
    end
  end
end
