# Public: Model for income database table.
class Income < ActiveRecord::Base
  belongs_to :user

  has_many :acct_trans, as: :transactable

  validates :user, :budget_date, presence: true
end
