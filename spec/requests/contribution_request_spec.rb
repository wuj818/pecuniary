RSpec.describe 'Contribution Requests' do
  describe 'GET index' do
    it 'returns a successful response' do
      get contributions_path

      expect(response).to be_successful
    end
  end

  describe 'GET show' do
    let(:contribution) { stub_contribution }

    it 'returns a successful response' do
      expect(Contribution).to receive(:find_by!).with(permalink: contribution.to_param).and_return contribution

      get contribution_path(contribution)

      expect(response).to be_successful
    end
  end

  describe 'GET new' do
    let(:asset) { stub_asset }

    let(:request!) { get new_financial_asset_contribution_path(asset) }

    context 'logged in' do
      it 'returns a successful response' do
        request_spec_login
        expect(FinancialAsset).to receive(:find_by!).with(permalink: asset.to_param).and_return asset
        expect(asset.contributions).to receive(:build).and_return stub_contribution.as_new_record

        request!

        expect(response).to be_successful
      end
    end

    context 'logged out' do
      it 'redirects to the login page' do
        request!

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'POST create' do
    let(:asset) { stub_asset }
    let(:contribution) { stub_contribution asset: asset }

    let(:request!) { post financial_asset_contributions_path(asset, contribution: { test: 1 }) }

    context 'logged in' do
      before do
        request_spec_login
        expect(FinancialAsset).to receive(:find_by!).with(permalink: asset.to_param).and_return asset
        expect(asset.contributions).to receive(:build).and_return contribution
      end

      describe 'with valid params' do
        it 'creates a new contribution and redirects to its asset' do
          expect(contribution).to receive(:save).and_return true

          request!

          expect(response).to redirect_to asset
          expect(flash[:success]).to match(/created/i)
        end
      end

      describe 'with invalid params' do
        it "doesn't create a new contribution" do
          expect(contribution.as_new_record).to receive(:save).and_return false

          request!

          expect(response).to be_successful
        end
      end
    end

    context 'logged out' do
      it 'redirects to the login page' do
        request!

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'GET edit' do
    let(:contribution) { stub_contribution }

    let(:request!) { get edit_contribution_path(contribution) }

    context 'logged in' do
      it 'returns a successful response' do
        request_spec_login
        expect(Contribution).to receive(:find_by!).with(permalink: contribution.to_param).and_return contribution

        request!

        expect(response).to be_successful
      end
    end

    context 'logged out' do
      it 'redirects to the login page' do
        request!

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'PATCH update' do
    let(:contribution) { stub_contribution }

    let(:request!) { patch financial_asset_contribution_path(contribution.asset, contribution, contribution: { test: 1 }) }

    context 'logged in' do
      before do
        request_spec_login
        expect(Contribution).to receive(:find_by!).with(permalink: contribution.to_param).and_return contribution
      end

      describe 'with valid params' do
        it 'redirects to the contribution' do
          expect(contribution).to receive(:update).and_return true

          request!

          expect(response).to redirect_to contribution
          expect(flash[:success]).to match(/updated/i)
        end
      end

      describe 'with invalid params' do
        it "doesn't update the contribution" do
          expect(contribution).to receive(:update).and_return false

          request!

          expect(response).to be_successful
        end
      end
    end

    context 'logged out' do
      it 'redirects to the login page' do
        expect(Contribution).not_to receive(:find_by!)

        request!

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'DELETE destroy' do
    let(:contribution) { stub_contribution }

    let(:request!) { delete contribution_path(contribution) }

    context 'logged in' do
      it 'destroys the requested contribution and redirects to its asset' do
        request_spec_login
        expect(Contribution).to receive(:find_by!).with(permalink: contribution.to_param).and_return contribution
        expect(contribution).to receive(:destroy).and_return true

        request!

        expect(response).to redirect_to contribution.asset
        expect(flash[:success]).to match(/deleted/i)
      end
    end

    context 'logged out' do
      it 'redirects to the login page' do
        expect(Contribution).not_to receive(:find_by!)

        request!

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end
end
