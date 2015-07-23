# Public: This is the main controller for the application that all other
# controllers will inherit from
class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  # Internal: Checks if a user is authenticated. If the user is not uthenticated
  # render a 401 error. I use this instead of devise's authenticate_user! method
  # for ajax requests becuase if the user is not authnticated I simply want a
  # 401 error returned and not redirect the user to login.
  #
  # Returns nothing.
  def authenticated?
    return if user_signed_in?

    render nothing: true, status: :unauthorized
  end
end
