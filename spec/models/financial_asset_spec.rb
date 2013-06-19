require 'spec_helper'

describe FinancialAsset do
  describe 'validations' do
    it 'requires a name' do
      asset = FinancialAsset.create
      asset.errors[:name].should include "can't be blank"
    end
  end
end
