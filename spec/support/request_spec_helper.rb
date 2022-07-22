# frozen_string_literal: true

module RequestSpecHelper
  def request_spec_login
    post sessions_path, params: { password: admin_password }
  end

  def admin_password
    Rails.application.credentials.password[Rails.env.to_sym]
  end

  def admin_cookie
    response.cookies["admin"]
  end

  module Stubs
    def stub_contribution(stubs = {})
      defaults = { asset: stub_asset, amount: 9000, date: "2010-07-28", permalink: "july-28-2010" }
      stub_model Contribution, defaults.merge(stubs)
    end
  end
end
