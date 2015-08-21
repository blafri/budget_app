# Public: Model for acct_trans database table.
class AcctTran < ActiveRecord::Base
  attr_reader :prev_trans_amount

  validate :amount_must_be_greater_than_zero

  belongs_to :bank_account
  belongs_to :transactable, polymorphic: true

  validates :bank_account, :transactable, presence: true
  validates :trans_amount, presence: true, numericality: true
  validates :trans_date, presence: { message: 'is invalid' }
  validates :trans_type, presence: true,
                         inclusion: { in: %w(debit credit),
                                      message: '%{value} is not a valid '\
                                               'transaction type.' }

  # Public: Virtual attribute for trans_date. This is the getter method which
  # gets the date object and displays it as a string in the format dd/mm/yyyy
  #
  # Returns a String representation of a date in the format dd/mm/yyyy
  def trans_date_string
    return unless trans_date
    trans_date.strftime('%d/%m/%Y')
  end

  # Public: Virtual attribute for trans_date=. This is the setter method which
  # takes a date string and changes it to a date object an stores it in
  # trans_date.
  #
  # Returns nothing.
  def trans_date_string=(date_str)
    fail ArgumentError, 'invalid date' unless valid_date?(date_str)
    self.trans_date = Date.parse(date_str)

  rescue ArgumentError
    return
  end

  # Public: Overwrite the default writer method for trans_amount so that it will
  # add the current transaction value to an instance variable before updating it
  # for the purpose of traking the change.
  #
  # Returns nothing
  def trans_amount=(value)
    @prev_trans_amount ||= trans_amount unless new_record?

    super
  end

  # Public: Gives the singed amount of the transaction. For example if the
  # transaction is a debit transaction it give you a negative number to signal
  # a debit from the account.
  #
  # Example
  #
  #   trans = AcctTransaction.create(type: 'debit', trans_amount: 35, .......)
  #   trans.signed_amount
  #   # => -35
  #
  # Returns a BigDecimal indicating the signed value of the transaction
  def signed_amount
    return BigDecimal(0) unless trans_amount

    case trans_type
    when 'debit'
      -trans_amount
    when 'credit'
      trans_amount
    end
  end

  private

  # Internal: A simple check to see if a date is in the format dd/mm/yyyy. This
  # function does not do extensive testing it simple checks for a cetain number
  # of digits before the slases in the date.
  #
  # Returns True if format is invalid and False otherwise.
  def valid_date?(date_str)
    date_str.match(%r{^[0-9]{2}/[0-9]{2}/[0-9]{4}$})
  end

  # Internal: This validates that amount entered is greater than zero.
  #
  # Returns nothing.
  def amount_must_be_greater_than_zero
    return unless trans_amount.present? && trans_amount < 1

    errors.add(:trans_amount, 'must be greater than 0')
  end
end
