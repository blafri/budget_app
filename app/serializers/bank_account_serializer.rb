# Public: Serializes a bank account object to json.
class BankAccountSerializer < ActiveModel::Serializer
  include ActiveSupport::NumberHelper

  attributes :id, :user_id, :name, :balance, :active, :formated_balance

  # Public: formats the balance with a $ sign as well as puting , every three
  # zeros.
  #
  # Returns a String with the account balance.
  def formated_balance
    number_to_currency object.balance
  end
end
