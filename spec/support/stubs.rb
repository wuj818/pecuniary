module Stubs
  def stub_asset(stubs = {})
    @stub_asset ||= stub_model(FinancialAsset, stubs).as_null_object
  end
end
