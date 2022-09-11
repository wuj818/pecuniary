# frozen_string_literal: true

RSpec.shared_examples "authentication required" do
  context "when logged out" do
    it "redirects to the login page" do
      request!

      expect(response).to redirect_to(login_url)
      expect(flash[:warning]).to match(/must be logged in/i)
    end
  end
end
