module Api
  module V1
    class BankAccountsController < Api::BaseController
      def show
        @account = BankAccount.find(params[:id])
        authorize @account
        respond_with @account
      end

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
