# Public: Controller for bank accounts.
class BankAccountsController < ApplicationController
  before_action :authenticate_user!

  after_action :verify_authorized, except: [:index]

  def index
    @accounts = current_user.bank_accounts
    respond_with @accounts
  end

  def new
    @account = current_user.bank_accounts.build
    authorize @account
    respond_with @account
  end

  def create
    @account = current_user.bank_accounts.build account_params
    authorize @account
    @account.save
    respond_with @account, location: -> { bank_accounts_path }
  end

  def destroy
    @account = current_user.bank_accounts.find(params[:id])
    authorize @account
    @account.destroy
    respond_with @account
  end

  private

  def account_params
    params.require(:bank_account).permit(:name, balance_allowed)
  end

  # Public: Balance is only allowed to be set when you are creating an account,
  # it is not allowed when you are editing an account.
  #
  # Returns a balance Symbol if you are allowed to edit balance and nil if you
  #   are not.
  def balance_allowed
    return :balance if action_name == 'create'
  end
end
