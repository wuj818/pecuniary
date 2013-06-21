require 'spec_helper'

describe AssetSnapshot do
  describe 'associations' do
    it 'belongs to asset' do
      snapshot = AssetSnapshot.make!
      snapshot.asset.should be_a FinancialAsset
    end
  end

  describe 'callbacks' do
    let(:date) { Date.new 2010, 7, 28 }
    let(:snapshot) { AssetSnapshot.make! date: date, asset: FinancialAsset.make!(name: 'Bank') }

    it 'sets the date to the end of the month' do
      snapshot.date.should_not == date
      snapshot.date.should == date.end_of_month
    end

    it 'creates a permalink from the asset, month, and year' do
      snapshot.permalink.should == 'bank-july-2010'
    end
  end

  describe 'instance methods' do
    describe 'to_param' do
      it "doesn't change until after the record is saved" do
        snapshot = AssetSnapshot.make! date: Date.new(2010, 7, 28), asset: FinancialAsset.make!(name: 'Bank')
        old_to_param = snapshot.to_param

        snapshot.permalink = 'test'
        snapshot.to_param.should == old_to_param

        snapshot.date = Date.new(2011, 3, 28)
        snapshot.save
        snapshot.to_param.should_not == old_to_param
      end
    end
  end

  describe 'validations' do
    it 'has required attributes' do
      snapshot = AssetSnapshot.create

      [:asset, :date].each do |attribute|
        snapshot.errors[attribute].should include "can't be blank"
      end
    end

    it 'requires a unique date/asset pair' do
      snapshot1 = AssetSnapshot.make!
      snapshot2 = AssetSnapshot.make asset: snapshot1.asset, date: snapshot1.date
      snapshot2.save

      snapshot2.errors[:date].should include 'has already been taken for this asset'
    end

    it 'is destroyed when the asset is destroyed' do
      snapshot = AssetSnapshot.make!
      snapshot.asset.destroy

      expect { snapshot.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
