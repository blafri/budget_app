require 'application_responder'

# Public: This is the main controoler for the application that all other
# controllers will inherit from
class ApplicationController < ActionController::Base
  include Pundit

  self.responder = ApplicationResponder

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
