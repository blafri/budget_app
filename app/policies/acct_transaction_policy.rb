class AcctTransactionPolicy < ApplicationPolicy
  def new?
    user.present?
  end

  def create?
    user.present? && record.bank_account.user_id == user.id
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
