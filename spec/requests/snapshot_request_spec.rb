# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/snapshots" do
  describe "GET /show" do
    let(:snapshot) { create(:snapshot) }

    it "returns a successful response" do
      get snapshot_url(snapshot)

      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    let(:asset) { create(:asset) }

    let(:request!) { get new_financial_asset_snapshot_url(asset) }

    context "when logged in" do
      it "returns a successful response" do
        request_spec_login

        request!

        expect(response).to be_successful
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        request!

        expect(response).to redirect_to(login_url)
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe "POST /create" do
    let(:asset) { create(:asset) }

    let(:request!) { post financial_asset_snapshots_url(asset), params: params }

    let(:params) { { snapshot: snapshot_params } }
    let(:snapshot_params) { nil }

    context "when logged in" do
      before { request_spec_login }

      context "with valid params" do
        let(:snapshot_params) { attributes_for(:snapshot) }

        it "creates a new snapshot and redirects to its asset" do
          expect { request! }.to change(Snapshot, :count).by(1)

          expect(response).to redirect_to(asset)
          expect(flash[:success]).to match(/created/i)
        end
      end

      context "with invalid params" do
        let(:snapshot_params) { attributes_for(:invalid_snapshot) }

        it "doesn't create a new snapshot" do
          expect { request! }.not_to change(Snapshot, :count)

          expect(response).to be_successful
        end
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        request!

        expect(response).to redirect_to(login_url)
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe "GET /edit" do
    let(:snapshot) { create(:snapshot) }

    let(:request!) { get edit_snapshot_url(snapshot) }

    context "when logged in" do
      it "returns a successful response" do
        request_spec_login

        request!

        expect(response).to be_successful
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        request!

        expect(response).to redirect_to(login_url)
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe "PATCH /update" do
    let!(:snapshot) { create(:snapshot) }
    let(:asset) { snapshot.asset }

    let(:request!) do
      patch financial_asset_snapshot_url(asset, snapshot), params: params
      snapshot.reload
    end

    let(:params) { { snapshot: snapshot_params } }
    let(:snapshot_params) { nil }

    context "when logged in" do
      before { request_spec_login }

      context "with valid params" do
        let(:new_value) { snapshot.value + 1 }

        let(:snapshot_params) { { value: new_value } }

        it "redirects to the updated snapshot" do
          expect { request! }.to change(snapshot, :value).to(new_value)

          expect(response).to redirect_to(snapshot)
          expect(flash[:success]).to match(/updated/i)
        end
      end

      context "with invalid params" do
        let(:snapshot_params) { attributes_for(:invalid_snapshot) }

        it "doesn't update the snapshot" do
          expect { request! }.not_to change(snapshot, :attributes)

          expect(response).to be_successful
        end
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        request!

        expect(response).to redirect_to(login_url)
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:snapshot) { create(:snapshot) }
    let(:asset) { snapshot.asset }

    let(:request!) { delete snapshot_url(snapshot) }

    context "when logged in" do
      it "destroys the requested snapshot and redirects to its asset" do
        request_spec_login

        expect { request! }.to change(Snapshot, :count).by(-1)

        expect(response).to redirect_to(asset)
        expect(flash[:success]).to match(/deleted/i)
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        request!

        expect(response).to redirect_to(login_url)
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end
end
