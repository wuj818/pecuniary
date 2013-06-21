require 'spec_helper'

describe FinancialAsset do
  describe 'associations' do
    it 'has many snapshots' do
      asset = FinancialAsset.make!
      snapshot = AssetSnapshot.make! asset: asset

      asset.snapshots.count.should == 1
      asset.snapshots.first.should be_an AssetSnapshot
    end
  end

  describe 'callbacks' do
    it 'creates a parameterized permalink' do
      asset = FinancialAsset.make! name: 'Roth IRA'
      asset.permalink.should == 'roth-ira'
    end
  end

  describe 'instance methods' do
    describe 'to_param' do
      it "doesn't change until after the record is saved" do
        asset = FinancialAsset.make! name: 'Bank'
        old_to_param = asset.to_param

        asset.permalink = 'test'
        asset.to_param.should == old_to_param

        asset.name = 'Roth IRA'
        asset.save
        asset.to_param.should_not == old_to_param
      end
    end
  end

  describe 'validations' do
    it 'has required attributes' do
      asset = FinancialAsset.create

      [:name].each do |attribute|
        asset.errors[attribute].should include "can't be blank"
      end
    end

    it 'requires a unique name' do
      asset1 = FinancialAsset.make!
      asset2 = FinancialAsset.make name: asset1.name
      asset2.save

      asset2.errors[:name].should include 'has already been taken'
    end
  end
end
