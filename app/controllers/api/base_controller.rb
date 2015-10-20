module Api
  # Public: Default controller for all APIs
  class BaseController < ApplicationController
    before_action :check_authenticated

    after_action :verify_authorized

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    rescue_from ActiveRecord::RecordNotFound, with: :object_not_found
    
    respond_to :json

    private

    # Internal: If user is not authorized to perform the action return a 403
    # status code.
    #
    # Returns nothing.
    def user_not_authorized
      render nothing: true, status: :forbidden
    end

    # Internal: If an active record object is not found return a 404 status
    # code.
    # Returns nothing.
    def object_not_found
      render nothing: true, status: :not_found
    end

    # Internal: Checks to see if the user is authenticated. If the user is not
    # authenticated it will return a unauthorized response code.
    #
    # Returns nothing.
    def check_authenticated
      return if user_signed_in?

      render nothing: true, status: :unauthorized
    end

    # Internal: Turns off the root node for the json serializers.
    #
    # Returns nothing.
    def default_serializer_options
      { root: false }
    end
  end
end
