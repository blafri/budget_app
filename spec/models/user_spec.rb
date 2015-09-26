require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it { should validate_presence_of(:email) }
  end

  context 'associations' do
    it { should have_many(:bank_accounts).dependent(:destroy) }
    it { should have_many(:incomes) }
  end
end
