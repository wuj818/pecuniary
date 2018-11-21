require 'rails_helper'

RSpec.describe ContributionsController do
  describe 'GET index' do
    it 'assigns all contributions as @contributions' do
      expect(Contribution).to receive(:includes).with(:asset).and_return(mock_relation)
      expect(mock_relation).to receive(:order).with('date DESC').and_return(mock_relation)

      get :index

      expect(response).to render_template :index
      expect(assigns(:contributions)).to eq(mock_relation)
    end
  end

  describe 'GET show' do
    it 'assigns the requested contribution as @contribution and its asset as @asset' do
      contribution = stub_contribution(permalink: 'bank-july-28-2010')
      expect(Contribution).to receive(:find_by_permalink).and_return(contribution)

      get :show, params: { id: contribution.to_param }

      expect(response).to render_template :show
      expect(assigns(:contribution)).to eq(contribution)
      expect(assigns(:asset)).to eq(contribution.asset)
    end
  end

  describe 'GET new' do
    before do
      @asset = stub_asset(permalink: 'bank')
    end

    context 'when logged in' do
      it 'assigns a new contribution as @contribution' do
        controller.login
        expect(FinancialAsset).to receive(:find_by_permalink).and_return(@asset)
        expect(@asset.contributions).to receive(:build).and_return(stub_contribution(new_record?: true, asset: @asset))

        get :new, params: { financial_asset_id: @asset.to_param }

        expect(response).to render_template :new
        expect(assigns(:contribution)).to be_a_new Contribution
        expect(assigns(:contribution).asset).to eq(@asset)
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get :new, params: { financial_asset_id: @asset.to_param }

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match /must be logged in/i
      end
    end
  end

  describe 'POST create' do
    before do
      @asset = stub_asset(permalink: 'bank')
      @contribution = stub_contribution(new_record?: true, asset: @asset)
    end

    context 'when logged in' do
      before do
        controller.login
        expect(FinancialAsset).to receive(:find_by_permalink).and_return(@asset)
        expect(@asset.contributions).to receive(:build).and_return(@contribution)
      end

      describe 'with valid params' do
        it 'creates a new contribution and redirects to its asset' do
          expect(@contribution).to receive(:save).and_return(true)

          post :create, params: { financial_asset_id: @asset.to_param, contribution: { test: 1 } }

          expect(response).to redirect_to @asset
          expect(flash[:success]).to match /created/i
        end
      end

      describe 'with invalid params' do
        it "renders the 'new' template" do
          expect(@contribution).to receive(:save).and_return(false)

          post :create, params: { financial_asset_id: @asset.to_param, contribution: { test: 1 } }

          expect(response).to render_template :new
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        post :create, params: { financial_asset_id: @asset.to_param, contribution: { test: 1 } }

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match /must be logged in/i
      end
    end
  end

  describe 'GET edit' do
    before do
      @asset = stub_asset(permalink: 'bank')
      @contribution = stub_contribution(permalink: 'bank-july-28-2010', asset: @asset)
    end

    context 'when logged in' do
      it 'assigns the requested contribution as @contribution' do
        controller.login
        expect(Contribution).to receive(:find_by_permalink).and_return(@contribution)

        get :edit, params: { id: @contribution.to_param }

        expect(response).to render_template :edit
        expect(assigns(:contribution)).to eq(@contribution)
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get :edit, params: { id: @contribution.to_param }

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match /must be logged in/i
      end
    end
  end

  describe 'PUT update' do
    before do
      @asset = stub_asset(permalink: 'bank')
      @contribution = stub_contribution(permalink: 'bank-july-28-2010', asset: @asset)
    end

    context 'when logged in' do
      before do
        controller.login
        expect(Contribution).to receive(:find_by_permalink).and_return(@contribution)
      end

      describe 'with valid params' do
        it 'redirects to the contribution' do
          expect(@contribution).to receive(:update).and_return(true)

          put :update, params: { id: @contribution.to_param, contribution: { test: 1 } }

          expect(response).to redirect_to @contribution
          expect(flash[:success]).to match /updated/i
        end
      end

      describe 'with invalid params' do
        it "renders the 'edit' template" do
          expect(@contribution).to receive(:update).and_return(false)

          put :update, params: { id: @contribution.to_param, contribution: { test: 1 } }

          expect(response).to render_template :edit
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        put :update, params: { id: @contribution.to_param, contribution: { test: 1 } }

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match /must be logged in/i
      end
    end
  end

  describe 'DELETE destroy' do
    before do
      @asset = stub_asset(permalink: 'bank')
      @contribution = stub_contribution(permalink: 'bank-july-28-2010', asset: @asset)
    end

    context 'when logged in' do
      it 'destroys the requested contribution and redirects to its asset' do
        controller.login
        expect(Contribution).to receive(:find_by_permalink).and_return(@contribution)
        expect(@contribution).to receive(:destroy).and_return(true)

        delete :destroy, params: { id: @contribution.to_param }

        expect(response).to redirect_to @asset
        expect(flash[:success]).to match /deleted/i
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        delete :destroy, params: { id: @contribution.to_param }

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match /must be logged in/i
      end
    end
  end
end
