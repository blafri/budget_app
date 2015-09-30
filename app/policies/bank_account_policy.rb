# Public: Authorization policy for bank accounts controller.
class BankAccountPolicy < ApplicationPolicy
  def new?
    user.present?
  end

  def show?
    record.user == user
  end

  def create?
    record.user == user
  end

  def update?
    record.user == user
  end

  def destroy?
    create?
  end
end
