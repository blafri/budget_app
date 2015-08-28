module BudgetApp
  # Public: Use this class to create transactions from controllers. When you use
  # this class to create the transactions it will automatically update the
  # balance on the account.
  class Transaction
    attr_reader :transaction

    # Public: Initialize the class by passing a AcctTran object to it. It will
    # determine the account to update based on the account the AcctTran
    # object is linked to.
    #
    # Returns a new BudgetApp::Transaction object.
    def initialize(transaction)
      @transaction = transaction
      @account = transaction.bank_account
    end

    private

    attr_reader :account

    # Internal: Saves the new transaction and updates the account balance
    # accordingly.
    #
    # Returns True if the transaction was saved and the account balance
    #   was updated, otherwise false.
    def save_tran_and_update_account(amount)
      ActiveRecord::Base.transaction do
        transaction.save!
        account.update_balance_by!(amount)
      end

    rescue ActiveRecord::RecordInvalid
      false
    end
  end
end
