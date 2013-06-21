module Stubs
  def stub_asset(stubs = {})
    @stub_asset ||= stub_model(FinancialAsset, stubs).as_null_object
  end

  def stub_asset_snapshot(stubs = {})
    @stub_asset_snapshot ||= stub_model(AssetSnapshot, stubs).as_null_object
  end
end
