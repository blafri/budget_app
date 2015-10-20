class AcctTranSerializer < ActiveModel::Serializer
  include ActiveSupport::NumberHelper

  attributes :id, :bank_account_id, :trans_type, :trans_amount, :description,
             :trans_date, :formated_trans_amount

  def formated_trans_amount
    number_to_currency object.trans_amount
  end
end
