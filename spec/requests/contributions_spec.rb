require 'rails_helper'

RSpec.describe 'Contributions' do
  describe 'GET index' do
    it 'returns a successful response' do
      expect(Contribution).to receive(:includes).with(:asset).and_return mock_relation
      expect(mock_relation).to receive(:order).with('date DESC').and_return mock_relation

      get contributions_path

      expect(response).to have_http_status :ok
    end
  end

  describe 'GET show' do
    it 'returns a successful response' do
      contribution = stub_contribution
      expect(Contribution).to receive(:find_by).with(permalink: contribution.to_param).and_return contribution

      get contribution_path(contribution)

      expect(response).to have_http_status :ok
    end
  end

  describe 'GET new' do
    let(:asset) { stub_asset }

    context 'when logged in' do
      it 'returns a successful response' do
        request_spec_login
        expect(FinancialAsset).to receive(:find_by).with(permalink: asset.to_param).and_return asset
        expect(asset.contributions).to receive(:build).and_return stub_contribution.as_new_record

        get new_financial_asset_contribution_path(asset)

        expect(response).to have_http_status :ok
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get new_financial_asset_contribution_path(asset)

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'POST create' do
    let(:asset) { stub_asset }
    let(:contribution) { stub_contribution asset: asset }

    context 'when logged in' do
      before do
        request_spec_login
        expect(FinancialAsset).to receive(:find_by).with(permalink: asset.to_param).and_return asset
        expect(asset.contributions).to receive(:build).and_return contribution
      end

      describe 'with valid params' do
        it 'creates a new contribution and redirects to its asset' do
          expect(contribution).to receive(:save).and_return true

          post financial_asset_contributions_path(asset, contribution: { test: 1 })

          expect(response).to redirect_to asset
          expect(flash[:success]).to match(/created/i)
        end
      end

      describe 'with invalid params' do
        it "doesn't create a new contribution" do
          expect(contribution.as_new_record).to receive(:save).and_return false

          post financial_asset_contributions_path(asset, contribution: { test: 1 })

          expect(response).to have_http_status :ok
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        post financial_asset_contributions_path(asset, contribution: { test: 1 })

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'GET edit' do
    let(:contribution) { stub_contribution }

    context 'when logged in' do
      it 'returns a successful response' do
        request_spec_login
        expect(Contribution).to receive(:find_by).with(permalink: contribution.to_param).and_return contribution

        get edit_contribution_path(contribution)

        expect(response).to have_http_status :ok
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get edit_contribution_path(contribution)

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'PATCH update' do
    let(:contribution) { stub_contribution }

    context 'when logged in' do
      before do
        request_spec_login
        expect(Contribution).to receive(:find_by).with(permalink: contribution.to_param).and_return contribution
      end

      describe 'with valid params' do
        it 'redirects to the contribution' do
          expect(contribution).to receive(:update).and_return true

          patch contribution_path(contribution, contribution: { test: 1 })

          expect(response).to redirect_to contribution
          expect(flash[:success]).to match(/updated/i)
        end
      end

      describe 'with invalid params' do
        it "doesn't update the contribution" do
          expect(contribution).to receive(:update).and_return false

          patch contribution_path(contribution, contribution: { test: 1 })

          expect(response).to have_http_status :ok
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        expect(Contribution).not_to receive(:find_by)

        patch contribution_path(contribution, contribution: { test: 1 })

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'DELETE destroy' do
    let(:contribution) { stub_contribution }

    context 'when logged in' do
      it 'destroys the requested contribution and redirects to its asset' do
        request_spec_login
        expect(Contribution).to receive(:find_by).with(permalink: contribution.to_param).and_return contribution
        expect(contribution).to receive(:destroy).and_return true

        delete contribution_path(contribution)

        expect(response).to redirect_to contribution.asset
        expect(flash[:success]).to match(/deleted/i)
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        expect(Contribution).not_to receive(:find_by)

        delete contribution_path(contribution)

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end
end
