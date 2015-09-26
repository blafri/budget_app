# Public: Model for bank_accounts table.
class BankAccount < ActiveRecord::Base
  belongs_to :user
  has_many :acct_trans, dependent: :destroy

  validates :user, :name, presence: true
  validates :balance, numericality: { message: 'must be a number' }

  # Public: Updates the balance on the account by the specified value.
  #
  # amount - BigDecimal indicating the amount to change the balance by.
  #
  # Returns nothing.
  def update_balance_by!(amount)
    return if amount == 0

    self.balance += amount
    save!
  end
end
