# Public: This is the model for the bank_accounts table.
#
# == Schema Information
#
# Table name: bank_accounts
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null, foreign key
#  name       :string           not null
#  balance    :decimal(12, 2)   not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
class BankAccount < ActiveRecord::Base
  belongs_to :user

  has_many :acct_transactions, dependent: :delete_all

  validates :user, presence: true
  validates :name, presence: true
  validates :balance, presence: true, numericality: true

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
