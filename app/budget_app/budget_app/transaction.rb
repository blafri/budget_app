module BudgetApp
  # Public: Use this class to create transactions from controllers. When you use
  # this class to create the transactions it will automatically update the
  # balance on the associated account.
  class Transaction
    # Public: Initialize the class by passing a AcctTran object to it. It will
    # determine the account to update based on the account the AcctTran
    # object is linked to.
    #
    # Returns a new BudgetApp::Transaction object.
    def initialize(transaction)
      @transaction = transaction
      @account = transaction.bank_account
    end

    # Public: Use this method to create a new transaction.
    #
    # Returns True if the transaction was created and the account balance
    #   was updated, otherwise False.
    def create
      save_tran_and_update_account(transaction.signed_amount)
    end

    # Public: Use this method to update an existing transaction.
    #
    # Returns True if the transaction was updated and the account balance
    #   was updated, otherwise False.
    def update
      save_tran_and_update_account(transaction_diff)
    end

    # Public: Use this method to destroy a transaction and update the account
    # balance accordingly.
    #
    # Returns True if the transaction was destroyed and the account balance
    # updated accordingly, otherwise False.
    def destroy
      ActiveRecord::Base.transaction do
        transaction.destroy!
        account.update_balance_by!(-transaction.signed_amount)
      end

    rescue ActiveRecord::RecordNotDestroyed
      false
    end

    private

    attr_reader :account
    attr_reader :transaction

    # Internal: This method is used when updating a transaction. It calculates
    # the difference between the previous amount of the transaction and the new
    # transaction amount. It can then be used to update the balance of the
    # account accordingly.
    #
    # Returns a BigDecimal object that is the difference between the new and old
    #   transaction amounts.
    def transaction_diff
      return BigDecimal(0) unless transaction.prev_trans_amount

      if transaction.trans_type == 'credit'
        transaction.signed_amount - transaction.prev_trans_amount
      else
        transaction.signed_amount + transaction.prev_trans_amount
      end
    end

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
