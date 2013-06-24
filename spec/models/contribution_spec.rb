require 'spec_helper'

describe Contribution do
  describe 'associations' do
    it 'belongs to asset' do
      contribution = Contribution.make!
      contribution.asset.should be_a FinancialAsset
    end
  end

  describe 'callbacks' do
    let(:date) { Date.new 2010, 7, 28 }
    let(:contribution) { Contribution.make! date: date, asset: FinancialAsset.make!(name: 'Bank') }

    it 'creates a permalink from the asset, month, day, and year' do
      contribution.permalink.should == 'bank-july-28-2010'
    end

    it "updates its asset's total contributions with the sum of all contributions" do
      asset = contribution.asset
      contribution.amount.should == asset.total_contributions

      expect do
        contribution.update_attribute :amount, contribution.amount + 1
      end.to change(asset, :total_contributions).from(asset.total_contributions).to(asset.total_contributions + 1)

      expect do
        Contribution.make! date: Date.new(2011, 3, 28), amount: 9000, asset: contribution.asset
      end.to change(asset, :total_contributions).from(asset.total_contributions).to(asset.total_contributions + 9000)

      expect do
        asset.contributions.order('date DESC').first.destroy
        asset.reload
      end.to change(asset, :total_contributions).from(asset.total_contributions).to(asset.total_contributions - 9000)
    end
  end

  describe 'instance methods' do
    describe 'to_param' do
      it "doesn't change until after the record is saved" do
        contribution = Contribution.make! date: Date.new(2010, 7, 28), asset: FinancialAsset.make!(name: 'Bank')
        old_to_param = contribution.to_param

        contribution.permalink = 'test'
        contribution.to_param.should == old_to_param

        contribution.date = Date.new(2011, 3, 28)
        contribution.save
        contribution.to_param.should_not == old_to_param
      end
    end
  end

  describe 'validations' do
    it 'has required attributes' do
      contribution = Contribution.create

      [:asset, :date].each do |attribute|
        contribution.errors[attribute].should include "can't be blank"
      end
    end

    it 'requires a unique date/asset pair' do
      contribution1 = Contribution.make!
      contribution2 = Contribution.make asset: contribution1.asset, date: contribution1.date
      contribution2.save

      contribution2.errors[:date].should include 'has already been taken for this asset'
    end

    it 'requires a positive non-zero amount' do
      [-1, 0].each do |amount|
        contribution = Contribution.create amount: amount
        contribution.errors[:amount].should include 'must be greater than 0'
      end
    end

    it 'requires an investment asset' do
      contribution = Contribution.new
      contribution.asset = FinancialAsset.make! name: 'Bank', investment: false
      contribution.save
      contribution.errors[:base].should include 'Bank is not a contributable investment'
    end

    it 'is destroyed when the asset is destroyed' do
      contribution = Contribution.make!
      contribution.asset.destroy

      expect { contribution.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
