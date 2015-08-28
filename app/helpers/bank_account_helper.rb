# Public: Helper methods for Bank accounts.
module BankAccountHelper
  # Public: Takes the account object and serializes it to JSON.
  #
  # Returns a Hash of the object.
  def account_to_json(account)
    BankAccountSerializer.new(account).to_json
  end
end
