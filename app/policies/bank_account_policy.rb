# Public: Authorization policy for Bank account model.
class BankAccountPolicy < ApplicationPolicy
  def new?
    user.present?
  end

  def create?
    user.present? && record.user_id == user.id
  end

  def edit?
    create?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
