# Public: This is the model for the bank account database table. This table will
# hold all the users bank accounts and the current balance in them.
class BankAccount < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
  validates :name, presence: true, uniqueness: { scope: :user_id,
                                                 message: 'already exists' }
  validates :balance, presence: true
end
