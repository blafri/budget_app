# Public: Authorization policy for bank accounts controller.
class BankAccountPolicy < ApplicationPolicy
  def new?
    user.present?
  end

  def show?
    record.user_id == user.id
  end

  def create?
    record.user_id == user.id
  end

  def update?
    record.user_id == user.id
  end

  def destroy?
    record.user_id == user.id
  end
end
