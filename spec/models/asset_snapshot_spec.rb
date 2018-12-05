require 'rails_helper'

RSpec.describe AssetSnapshot do
  describe 'associations' do
    it 'belongs to asset' do
      snapshot = create :asset_snapshot
      expect(snapshot.asset).to be_a FinancialAsset
    end
  end

  describe 'callbacks' do
    let(:date) { Date.new 2010, 7, 28 }
    let(:snapshot) { create :asset_snapshot, date: date, asset: create(:financial_asset, name: 'Bank') }

    it 'sets the date to the end of the current month by default' do
      snapshot = AssetSnapshot.new
      expect(snapshot.date).to eq Time.zone.now.to_date.end_of_month
    end

    it 'sets the date to the end of the month' do
      expect(snapshot.date).not_to eq date
      expect(snapshot.date).to eq date.end_of_month
    end

    it 'creates a permalink from the asset, month, and year' do
      expect(snapshot.permalink).to eq 'bank-july-2010'
    end

    it "updates its asset's current value with the most recent value" do
      asset = snapshot.asset
      expect(snapshot.value).to eq asset.current_value

      expect do
        snapshot.update value: snapshot.value + 1
      end.to change(asset, :current_value).from(asset.current_value).to asset.current_value + 1

      expect do
        create :asset_snapshot, date: Date.new(2011, 3, 28), value: 9000, asset: snapshot.asset
      end.to change(asset, :current_value).from(asset.current_value).to 9000

      expect do
        asset.snapshots.order('date DESC').first.destroy
        asset.reload
      end.to change(asset, :current_value).from(9000).to snapshot.value
    end
  end

  describe 'instance methods' do
    describe 'to_param' do
      it "doesn't change until after the record is saved" do
        snapshot = create :asset_snapshot, date: Date.new(2010, 7, 28), asset: create(:financial_asset, name: 'Bank')
        old_to_param = snapshot.to_param

        snapshot.permalink = 'test'
        expect(snapshot.to_param).to eq old_to_param

        snapshot.date = Date.new 2011, 3, 28
        snapshot.save
        expect(snapshot.to_param).not_to eq old_to_param
      end
    end
  end

  describe 'validations' do
    it 'has required attributes' do
      snapshot = AssetSnapshot.create

      [:asset].each do |attribute|
        expect(snapshot.errors[attribute]).to include "can't be blank"
      end
    end

    it 'requires a unique date/asset pair' do
      snapshot1 = create :asset_snapshot
      snapshot2 = build :asset_snapshot, asset: snapshot1.asset, date: snapshot1.date
      snapshot2.save

      expect(snapshot2.errors[:date]).to include 'has already been taken for this asset'
    end

    it 'is destroyed when the asset is destroyed' do
      snapshot = create :asset_snapshot
      snapshot.asset.destroy

      expect { snapshot.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
