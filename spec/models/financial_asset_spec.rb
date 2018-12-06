RSpec.describe FinancialAsset do
  describe 'associations' do
    it 'has many snapshots' do
      asset = create :financial_asset
      create :asset_snapshot, asset: asset

      expect(asset.snapshots.count).to eq 1
      expect(asset.snapshots.first).to be_an AssetSnapshot
    end
  end

  describe 'callbacks' do
    it 'creates a parameterized permalink' do
      asset = create :financial_asset, name: 'Roth IRA'
      expect(asset.permalink).to eq 'roth-ira'
    end

    it "updates all of its association's permalinks when its name changes" do
      asset = create :financial_asset, name: 'Bank'
      snapshot = create :asset_snapshot, asset: asset
      contribution = create :contribution, asset: asset

      expect(snapshot.permalink).to match 'bank'
      expect(contribution.permalink).to match 'bank'

      asset.update name: 'Roth IRA'

      snapshot.reload
      expect(snapshot.permalink).not_to match 'bank'
      expect(snapshot.permalink).to match 'roth-ira'

      contribution.reload
      expect(contribution.permalink).not_to match 'bank'
      expect(contribution.permalink).to match 'roth-ira'
    end
  end

  describe 'instance methods' do
    describe 'to_param' do
      it "doesn't change until after the record is saved" do
        asset = create :financial_asset, name: 'Bank'
        old_to_param = asset.to_param

        asset.permalink = 'test'
        expect(asset.to_param).to eq old_to_param

        asset.name = 'Roth IRA'
        asset.save
        expect(asset.to_param).not_to eq old_to_param
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
      asset1 = create :financial_asset
      asset2 = build :financial_asset, name: asset1.name
      asset2.save

      expect(asset2.errors[:name]).to include 'has already been taken'
    end
  end
end
