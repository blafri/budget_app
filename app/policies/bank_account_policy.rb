# Public: Authorization policy for bank accounts controller.
class BankAccountPolicy < ApplicationPolicy
  def new?
    record.user == user
  end

  def create?
    new?
  end

  def destroy?
    new?
  end
end
