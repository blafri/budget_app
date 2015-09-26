require 'rails_helper'

RSpec.describe Income, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:acct_tran)}
  end

  context 'validations' do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:acct_tran) }
  end
end
