require 'spec_helper'

describe FinancialAsset do
  describe 'validations' do
    it 'requires a name' do
      asset = FinancialAsset.create
      asset.errors[:name].should include "can't be blank"
    end

    it 'requires a unique name' do
      asset1 = FinancialAsset.make!
      asset2 = FinancialAsset.make name: asset1.name
      asset2.save
      asset2.errors[:name].should include 'has already been taken'
    end
  end

  describe 'callbacks' do
    it 'creates a parameterized permalink' do
      asset = FinancialAsset.make! name: 'Roth IRA'
      asset.permalink.should == 'roth-ira'
    end
  end
end
