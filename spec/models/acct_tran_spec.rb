require 'rails_helper'

RSpec.describe AcctTran, type: :model do
  context 'validations' do
    it { should validate_presence_of(:bank_account) }
    it { should validate_presence_of(:transactable) }
    it { should validate_presence_of(:trans_amount) }
    it { should validate_numericality_of(:trans_amount) }
    it { should validate_presence_of(:trans_type) }

    it do
      should validate_inclusion_of(:trans_type).
        in_array(%w(debit credit))
    end

    it 'should validate the presence of trans_date' do
      tran = AcctTran.new
      tran.valid?
      expect(tran.errors[:trans_date].first).to eq('is invalid')
    end

    it 'should validate that trans_amount is greater than 0' do
      tran = AcctTran.new(trans_amount: -90.34)
      tran.valid?
      expect(tran.errors[:trans_amount].first).to eq('must be greater than 0')
    end
  end

  context 'associations' do
    it { should belong_to(:bank_account) }
    it { should belong_to(:transactable) }
  end

  context '#trans_date_string' do
    it 'should return a formated date string' do
      tran = AcctTran.new(trans_date: Date.new(1985,10,23))
      expect(tran.trans_date_string).to eq('23/10/1985')
    end

    it 'should return nil of no date set' do
      tran = AcctTran.new
      expect(tran.trans_date_string).to eq(nil)
    end
  end

  context '#trans_date_string=' do
    it 'should set trans_date successfully' do
      tran = AcctTran.new(trans_date_string: '23/10/1985')
      expect(tran.trans_date).to eq(Date.new(1985,10,23))
    end

    it 'should not set a value if the date is invalid' do
      tran = AcctTran.new(trans_date_string: 'njksndks')
      expect(tran.trans_date).to eq(nil)
    end
  end

  context '#amount=' do
    let(:trans) { build(:acct_tran, trans_amount: 10.67) }
    context 'when new record' do
      it 'instance variable is not set' do
        trans.trans_amount = 1.57
        expect(trans.prev_trans_amount).to eq(nil)
      end
    end

    context 'when record is not new' do
      it 'should set instance variable for previous amount' do
        trans.save!
        trans.trans_amount = 1.57
        expect(trans.prev_trans_amount).to eq(BigDecimal('10.67'))
      end
    end
  end

  context '#signed_amount' do
    let(:trans) {build(:acct_tran, trans_amount: 10.91)}

    it 'should return 0 if trans_amount is not present' do
      trans.trans_amount = nil
      expect(trans.signed_amount).to eq(BigDecimal('0'))
    end

    it 'should return nil if trans_type is invalid' do
      trans.trans_type = 'nkjnkj'
      expect(trans.signed_amount).to eq(nil)
    end

    it 'should return a negative value for debit type' do
      trans.trans_type = 'debit'
      expect(trans.signed_amount).to eq(BigDecimal('-10.91'))
    end

    it 'should return a positive value for credit type' do
      trans.trans_type = 'credit'
      expect(trans.signed_amount).to eq(BigDecimal('10.91'))
    end
  end
end
