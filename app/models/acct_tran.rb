# Public: AR model for the acct_trans database table.
class AcctTran < ActiveRecord::Base
  belongs_to :bank_account
  has_one :income, dependent: :delete

  validates :bank_account, presence: true
  validates :trans_type, inclusion: { in: %w(credit debit),
                                      message: 'is not valid' }
end
