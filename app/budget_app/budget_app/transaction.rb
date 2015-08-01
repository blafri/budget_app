module BudgetApp
  class Transaction
    attr_reader :transaction

    def initialize(transaction)
      @transaction = transaction
      @account = transaction.bank_account
    end

    def create_transaction
      save_transaction_and_update_account(transaction.trans_amount)
    end

    def update_transaction
      save_transaction_and_update_account(transaction_diff)
    end

    def destroy_transaction
      ActiveRecord::Base.transaction do
        transaction.destroy!
        account.update_balance_by!(-transaction.trans_amount)
      end

    rescue ActiveRecord::RecordNotDestroyed
      false
    end

    private

    attr_reader :account

    def transaction_diff
      return BigDecimal(0) unless transaction.prev_trans_value

      transaction.trans_amount - transaction.prev_trans_value
    end

    def save_transaction_and_update_account(amount)
      ActiveRecord::Base.transaction do
        transaction.save!
        account.update_balance_by!(amount)
      end

    rescue ActiveRecord::RecordInvalid
      false
    end
  end
end