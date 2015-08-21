require 'rails_helper'

RSpec.describe Income, type: :model do
  context 'validations' do
    it { should validate_presence_of(:budget_date) }
    it { should validate_presence_of(:user) }
  end

  context 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:acct_trans) }
  end
end
