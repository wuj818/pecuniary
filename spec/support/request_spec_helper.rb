module RequestSpecHelper
  def request_spec_login
    post sessions_path, params: { password: Rails.application.credentials.password[Rails.env.to_sym] }
  end

  def admin_cookie
    response.cookies['admin']
  end

  module Stubs
    def stub_asset(stubs = {})
      defaults = { name: 'Bank', permalink: 'bank' }
      stub_model FinancialAsset, defaults.merge(stubs)
    end

    def stub_snapshot(stubs = {})
      defaults = { asset: stub_asset, value: 9000, date: '2010-07-28', permalink: 'july-28-2010' }
      stub_model Snapshot, defaults.merge(stubs)
    end

    def stub_contribution(stubs = {})
      defaults = { asset: stub_asset, amount: 9000, date: '2010-07-28', permalink: 'july-28-2010' }
      stub_model Contribution, defaults.merge(stubs)
    end

    def stub_milestone(stubs = {})
      defaults = { date: '2010-07-28', notes: '', permalink: 'july-28-2010' }
      stub_model Milestone, defaults.merge(stubs)
    end
  end
end
