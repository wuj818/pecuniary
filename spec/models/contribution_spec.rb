require 'rails_helper'

RSpec.describe Contribution do
  describe 'associations' do
    it 'belongs to asset' do
      contribution = Contribution.make!
      expect(contribution.asset).to be_a FinancialAsset
    end
  end

  describe 'callbacks' do
    let(:date) { Date.new 2010, 7, 28 }
    let(:contribution) { Contribution.make! date: date, asset: FinancialAsset.make!(name: 'Bank') }

    it 'sets the date to the current date by default' do
      Timecop.freeze
      contribution = Contribution.new
      expect(contribution.date).to eq(Time.zone.now.to_date)
    end

    it 'creates a permalink from the asset, month, day, and year' do
      expect(contribution.permalink).to eq('bank-july-28-2010')
    end

    it "updates its asset's total contributions with the sum of all contributions" do
      asset = contribution.asset
      expect(contribution.amount).to eq(asset.total_contributions)

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
        expect(contribution.to_param).to eq(old_to_param)

        contribution.date = Date.new(2011, 3, 28)
        contribution.save
        expect(contribution.to_param).not_to eq(old_to_param)
      end
    end
  end

  describe 'validations' do
    it 'has required attributes' do
      contribution = Contribution.create

      [:asset].each do |attribute|
        expect(contribution.errors[attribute]).to include "can't be blank"
      end
    end

    it 'requires a unique date/asset pair' do
      contribution1 = Contribution.make!
      contribution2 = Contribution.make asset: contribution1.asset, date: contribution1.date
      contribution2.save

      expect(contribution2.errors[:date]).to include 'has already been taken for this asset'
    end

    it 'requires an investment asset' do
      contribution = Contribution.new
      contribution.asset = FinancialAsset.make! name: 'Bank', investment: false
      contribution.save
      expect(contribution.errors[:base]).to include 'Bank is not a contributable investment'
    end

    it 'is destroyed when the asset is destroyed' do
      contribution = Contribution.make!
      contribution.asset.destroy

      expect { contribution.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
