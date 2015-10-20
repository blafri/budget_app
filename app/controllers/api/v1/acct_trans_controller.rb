module Api
  module V1
    class AcctTransController < Api::BaseController
      after_action :verify_authorized, :except => :index
      after_action :verify_policy_scoped, :only => :index
      
      def index
        @trans = policy_scope(AcctTran)
        respond_with @trans
      end
    end
  end
end
