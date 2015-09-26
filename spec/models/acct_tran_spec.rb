require 'rails_helper'

RSpec.describe AcctTran, type: :model do
  context 'associations' do
    it { should belong_to(:bank_account) }
    it { should have_one(:income).dependent(:delete)}
  end

  context 'validations' do
    it { should validate_presence_of(:bank_account) }
    it do
      should validate_inclusion_of(:trans_type).in_array(%w(credit debit))
        .with_message('is not valid')
    end
  end
end
