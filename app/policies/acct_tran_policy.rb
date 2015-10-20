class AcctTranPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(bank_account_id: user.bank_accounts.ids)
    end
  end
end
