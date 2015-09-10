module Api
  module V1
    # Public: This is the controller that hadles API request for bank accounts.
    class BankAccountsController < Api::BaseController
      def update
        @account = BankAccount.find(params[:id])
        authorize @account
        @account.update(account_params)
        respond_with @account
      end

      private

      def account_params
        params.require(:bank_account).permit(:name)
      end
    end
  end
end
