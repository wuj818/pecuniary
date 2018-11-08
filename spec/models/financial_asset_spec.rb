require 'rails_helper'

RSpec.describe FinancialAsset do
  describe 'associations' do
    it 'has many snapshots' do
      asset = FinancialAsset.make!
      snapshot = AssetSnapshot.make! asset: asset

      expect(asset.snapshots.count).to eq(1)
      expect(asset.snapshots.first).to be_an AssetSnapshot
    end
  end

  describe 'callbacks' do
    it 'creates a parameterized permalink' do
      asset = FinancialAsset.make! name: 'Roth IRA'
      expect(asset.permalink).to eq('roth-ira')
    end

    it "updates all of its association's permalinks when its name changes" do
      asset = FinancialAsset.make! name: 'Bank'
      snapshot = AssetSnapshot.make! asset: asset
      contribution = Contribution.make! asset: asset

      expect(snapshot.permalink).to match /bank/
      expect(contribution.permalink).to match /bank/

      asset.update_attributes name: 'Roth IRA'

      snapshot.reload
      expect(snapshot.permalink).not_to match /bank/
      expect(snapshot.permalink).to match /roth-ira/

      contribution.reload
      expect(contribution.permalink).not_to match /bank/
      expect(contribution.permalink).to match /roth-ira/
    end
  end

  describe 'instance methods' do
    describe 'to_param' do
      it "doesn't change until after the record is saved" do
        asset = FinancialAsset.make! name: 'Bank'
        old_to_param = asset.to_param

        asset.permalink = 'test'
        expect(asset.to_param).to eq(old_to_param)

        asset.name = 'Roth IRA'
        asset.save
        expect(asset.to_param).not_to eq(old_to_param)
      end
    end
  end

  describe 'validations' do
    it 'has required attributes' do
      asset = FinancialAsset.create

      [:name].each do |attribute|
        expect(asset.errors[attribute]).to include "can't be blank"
      end
    end

    it 'requires a unique name' do
      asset1 = FinancialAsset.make!
      asset2 = FinancialAsset.make name: asset1.name
      asset2.save

      expect(asset2.errors[:name]).to include 'has already been taken'
    end
  end
end
