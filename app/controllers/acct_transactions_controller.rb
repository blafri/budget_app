class AcctTransactionsController < ApplicationController
  before_action :setup_trans_type_arr, only: [:new, :edit]
  before_action :find_bank_account, only: [:new, :create]

  after_action :verify_authorized

  def new
    @trans = AcctTransaction.new
    authorize @trans
    respond_to :js
  end

  def create
    new_trans = BudgetApp::Transaction.new(@account.acct_transactions
      .build(trans_params))
    authorize new_trans.transaction

    if new_trans.create_transaction
      flash[:notice] = 'Transaction created successfully.'
    end

    @trans = new_trans.transaction
    respond_to :js
  end

  def edit
    @trans = AcctTransaction.find(params[:id])
    authorize @trans
    respond_to :js
  end

  def update
    trans = BudgetApp::Transaction.new(AcctTransaction.find(params[:id]))
    trans.transaction.assign_attributes(trans_params)
    authorize trans.transaction

    if @result = trans.update_transaction
      flash[:notice] = 'Transaction updated successfully.'
    end

    @trans = trans.transaction
    respond_to :js
  end

  def destroy
    trans = BudgetApp::Transaction.new(AcctTransaction.find(params[:id]))
    authorize trans.transaction

    if trans.destroy_transaction
      flash[:notice] = 'The transaction was deleted successfully.'
    else
      flash[:error] = 'There was a problem deleting the transaction. Please '\
                      'try again later.'
    end

    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

  private

  # Internal: Sets which params are allowed to be submitted and updated by a
  # user.
  #
  # Returns Hash of permitted parameters.
  def trans_params
    params.require(:acct_transaction).permit(trans_type_allowed,
                                             :amount,
                                             :description)
  end

  # Internal: Determines if the user is allowed to set the transaction type.
  # If the user is creating a transaction he is allowed to set the transaction
  # type but if he is updating a transaction he is not allowed to change the
  # transaction type. If he wants to change the transaction type he will have to
  # delete the current transaction and create a new one.
  #
  # Returns a Symbol of :trans_type if the user is allowed to update the
  #   type of transaction or nil if it is not.
  def trans_type_allowed
    return :trans_type if params[:action] == 'create'
  end

  # Internal: Finds the bank account that the current transaction is associated
  # with.
  #
  # Returns nothing.
  def find_bank_account
    @account = current_user.bank_accounts.find(params[:bank_account_id])
  end

  # Internal: Array of transaction types for use in the select box in the view.
  #
  # Returns nothing.
  def setup_trans_type_arr
    @trans_type_arr = AcctTransaction::SELECT_BOX_TRANS_TYPE
  end
end
