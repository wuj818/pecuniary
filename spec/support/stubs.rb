module Stubs
  def stub_asset(stubs = {})
    @stub_asset ||= stub_model FinancialAsset, stubs
  end

  def stub_asset_snapshot(stubs = {})
    @stub_asset_snapshot ||= stub_model AssetSnapshot, stubs
  end

  def stub_contribution(stubs = {})
    @stub_contribution ||= stub_model Contribution, stubs
  end

  def stub_milestone(stubs = {})
    @stub_milestone ||= stub_model Milestone, stubs
  end
end
