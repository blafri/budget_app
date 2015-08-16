# Public: Model for bank_accounts table.
class BankAccount < ActiveRecord::Base
  belongs_to :user

  validates :user, :name, presence: true
  validates :balance, numericality: { message: 'must be a number' }
end
