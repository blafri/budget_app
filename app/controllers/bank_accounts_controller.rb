# Public: Controller for bank account acctions.
class BankAccountsController < ApplicationController
  before_action :authenticated?
  before_action :find_bank_account, only: [:edit, :update, :destroy]

  after_action :verify_authorized

  def new
    @account = BankAccount.new
    authorize @account
    respond_to :js
  end

  def edit
    authorize @account
    respond_to :js
  end

  def create
    @account = current_user.bank_accounts.build(bank_account_params)
    authorize @account

    flash[:notice] = 'Account created successfully.' if @account.save

    respond_to :js
  end

  def update
    authorize @account
    @result = @account.update(bank_account_params)

    flash[:notice] = 'Account updated successfully.' if @result

    respond_to :js
  end

  def destroy
    authorize @account

    if @account.destroy
      flash[:notice] = 'Bank account deleted successfully.'
    else
      flash[:error] = 'There was a problem deleting the bank account. Please '\
                      'try again later.'
    end

    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

  private

  # Internal: Gets the bank account object from the database and assigns it to
  # an instance variable called @account.
  #
  # Returns nothing.
  def find_bank_account
    @account = current_user.bank_accounts.find(params[:id])
  end

  def bank_account_params
    params.require(:bank_account).permit(:name, balance_allowed)
  end

  # Internal: Determines if the user is allowed to set a balance. If the user is
  # creating an account he is allowed to set an initial balance, but if he is
  # updating an account he is only allowed to edit the name and not change the
  # balance.
  #
  # Returns a Symbol of :balance if the user is allowed to update the balance
  #  and nil if it is not.
  def balance_allowed
    return :balance if params[:action] == 'create'
  end
end
