# Public: This is the model for the acct_transactions table. It is where all
# transactions for bank accounts will be stored.
#
# == Schema Information
#
# Table name: acct_transactions
#
#  id              :integer          not null, primary key
#  bank_account_id :integer          not null, foreign key
#  type            :string           not null
#  amount          :decimal(12, 2)   not null
#  description     :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
class AcctTransaction < ActiveRecord::Base
  belongs_to :bank_account

  validate :amount_must_be_greater_than_zero

  validates :bank_account, :description, :trans_type, :amount, presence: true
  validates :bank_account, presence: true
  validates :description, presence: true
  validates :amount, presence: true, numericality: true
  validates :trans_type, presence: true,
                         inclusion: { in: %w(debit credit),
                                      message: "%{value} is not a valid "\
                                               'transaction type.' }

  # Public: An array that can be used in forms with select boxes for the
  # user to select the type of transaction.
  SELECT_BOX_TRANS_TYPE = [['Debit', 'debit'], ['Credit', 'credit']]

  # Public: Gets a list of all transactions for a list of accounts. The list of
  # transactions will be ordered from most recent to oldest.
  #
  # accounts - An Array of accounts for which to get the transactions.
  #
  # Examples
  #
  #   user_accounts = current_user.bank_accounts
  #   AcctTransaction.for_accounts(user_accounts)
  #   => list of transaction for the curently logged on user's accounts
  #
  # Returns an AcctTransaction::ActiveRecord_Relation object containing a list
  #   of all the transactions for the accounts given.
  def self.for_accounts(accounts)
    where(bank_account_id: accounts.map(&:id)).order(created_at: :desc)
  end

  # Public: Overwrite the default writer method for amount so that it will add
  # the current transaction value to an instance variable before updating it
  # for traking the change. This instance variable is used when calling the
  # method save_and_update_account so that when a transaction is updated you can
  # calculate the difference between the old transaction value and the new one
  # and update the account balance accordingly.
  #
  # Returns nothing
  def amount=(value)
    if new_record?
      @prev_trans_value ||= BigDecimal(0)
    else
      @prev_trans_value ||= trans_amount
    end

    super
  end

  # Public: Gives the singed amount of the transaction. For example if the
  # transaction is a debit transaction it give you a negative number to signal
  # a debit from the account.
  #
  # Example
  #
  #   trans = AcctTransaction.create(type: 'debit', amount: 35, .......)
  #   trans.trans_amount
  #   # => -35
  #
  # Returns a BigDecimal indicating the value of the transaction
  def trans_amount
    case trans_type
    when 'debit'
      -amount
    when 'credit'
      amount
    end
  end

  def save_and_update_account
    self.class.transaction do
      save!
      bank_account.update_balance_by!(transaction_diff)
    end

  rescue ActiveRecord::RecordInvalid
    false
  end

  def destroy_and_update_account
    self.class.transaction do
      destroy!
      bank_account.update_balance_by!(-trans_amount)
    end

    destroyed?

  rescue ActiveRecord::RecordNotDestroyed
    false
  end

  private

  def transaction_diff
    return BigDecimal(0) unless @prev_trans_value

    trans_amount - @prev_trans_value
  end

  # Internal: This validates that amount entered is greater than zero.
  #
  # Returns nothing.
  def amount_must_be_greater_than_zero
    if amount.present? && amount < 1
      errors.add(:amount, "must be greater than 0")
    end
  end
end