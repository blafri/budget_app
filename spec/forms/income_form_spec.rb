require 'rails_helper'

RSpec.describe IncomeForm do
  let(:user) { create(:user) }
  let(:account) { create(:bank_account, user: user, balance: 89.17) }
  let(:income) { create(:income, user: user) }

  context 'validations' do
    it 'trans_amount is greater than 0' do
      form = IncomeForm.new(income, trans_amount: 0)
      form.valid?
      expect(form.errors[:trans_amount].first).to eq('must be greater than 0')
    end

    it 'trans_date must be valid' do
      form = IncomeForm.new(income, trans_date: 'not valid')
      form.valid?
      expect(form.errors[:trans_date].first).to eq('is not valid')
    end

    it 'budget_month must be valid' do
      [201213, 201200, 2012, 12].each do |num|
        form = IncomeForm.new(income, budget_month: num)
        form.valid?
        expect(form.errors[:budget_month].first).to eq('is not valid')
      end
    end
  end

  context 'trans_date' do
    it 'is coerced properly when date is correct format' do
      form = IncomeForm.new(income, trans_date: '2012-12-12')
      form.valid?
      expect(form.trans_date).to eq(Date.new(2012,12,12))
    end

    it 'is set to nil if date format is not correct' do
      form = IncomeForm.new(income, trans_date: '12/12/2012')
      form.valid?
      expect(form.trans_date).to eq(nil)
    end
  end

  context 'create new income' do
    before do
      @new_income = user.incomes.build
      @new_income.build_acct_tran(bank_account: account)
    end

    it 'is successful' do
      form = IncomeForm.new(@new_income, budget_month: 201212,
                                         trans_amount: 100.22,
                                         description: 'test',
                                         trans_date: '2012-12-12')
      form.save
      expect(Income.first.budget_month).to eq(201212)
      expect(Income.first.acct_tran.trans_amount).to eq(BigDecimal('100.22'))
      expect(Income.first.acct_tran.description).to eq('test')
      expect(Income.first.acct_tran.trans_date).to eq(Date.new(2012,12,12))
      expect(BankAccount.first.balance).to eq(BigDecimal('189.39'))
    end
  end

  context 'update income' do
    it 'is successful' do
      form = IncomeForm.new(income, budget_month: 200001,
                                    trans_amount: 890,
                                    description: 'new desc',
                                    trans_date: '1999-12-31')
  
      form.save

      expect(Income.first.budget_month).to eq(200001)
      expect(Income.first.acct_tran.trans_amount).to eq(BigDecimal('890'))
      expect(Income.first.acct_tran.description).to eq('new desc')
      expect(Income.first.acct_tran.trans_date).to eq(Date.new(1999,12,31))
      expect(BankAccount.first.balance).to eq(BigDecimal('889.49'))
    end
  end
end
