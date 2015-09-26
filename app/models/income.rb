# Public: AR model for the incomes database table.
class Income < ActiveRecord::Base
  belongs_to :user
  belongs_to :acct_tran

  validates :user, presence: true
  validates :acct_tran, presence: true
end
