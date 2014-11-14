require 'rails_helper'

RSpec.describe AssetSnapshotsController do
  describe 'GET show' do
    it 'assigns the requested snapshot as @snapshot and its asset as @asset' do
      snapshot = stub_asset_snapshot(permalink: 'bank-july-2010')
      expect(AssetSnapshot).to receive(:find_by_permalink).and_return(snapshot)

      get :show, id: snapshot.to_param

      expect(response).to render_template :show
      expect(assigns(:snapshot)).to eq(snapshot)
      expect(assigns(:asset)).to eq(snapshot.asset)
    end
  end

  describe 'GET new' do
    before do
      @asset = stub_asset(permalink: 'bank')
    end

    context 'when logged in' do
      it 'assigns a new snapshot as @snapshot' do
        controller.login
        expect(FinancialAsset).to receive(:find_by_permalink).and_return(@asset)
        expect(@asset.snapshots).to receive(:build).and_return(stub_asset_snapshot(new_record?: true, asset: @asset))

        get :new, financial_asset_id: @asset.to_param

        expect(response).to render_template :new
        expect(assigns(:snapshot)).to be_a_new AssetSnapshot
        expect(assigns(:snapshot).asset).to eq(@asset)
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get :new, financial_asset_id: @asset.to_param

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match /must be logged in/i
      end
    end
  end

  describe 'POST create' do
    before do
      @asset = stub_asset(permalink: 'bank')
      @snapshot = stub_asset_snapshot(new_record?: true, asset: @asset)
    end

    context 'when logged in' do
      before do
        controller.login
        expect(FinancialAsset).to receive(:find_by_permalink).and_return(@asset)
        expect(@asset.snapshots).to receive(:build).and_return(@snapshot)
      end

      describe 'with valid params' do
        it 'creates a new snapshot and redirects to its asset' do
          expect(@snapshot).to receive(:save).and_return(true)

          post :create, financial_asset_id: @asset.to_param, asset_snapshot: {}

          expect(response).to redirect_to @asset
          expect(flash[:success]).to match /created/i
        end
      end

      describe 'with invalid params' do
        it "renders the 'new' template" do
          expect(@snapshot).to receive(:save).and_return(false)

          post :create, financial_asset_id: @asset.to_param, asset_snapshot: {}

          expect(response).to render_template :new
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        post :create, financial_asset_id: @asset.to_param, asset_snapshot: {}

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match /must be logged in/i
      end
    end
  end

  describe 'GET edit' do
    before do
      @asset = stub_asset(permalink: 'bank')
      @snapshot = stub_asset_snapshot(permalink: 'bank-july-2010', asset: @asset)
    end

    context 'when logged in' do
      it 'assigns the requested snapshot as @snapshot' do
        controller.login
        expect(AssetSnapshot).to receive(:find_by_permalink).and_return(@snapshot)

        get :edit, id: @snapshot.to_param

        expect(response).to render_template :edit
        expect(assigns(:snapshot)).to eq(@snapshot)
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get :edit, id: @snapshot.to_param

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match /must be logged in/i
      end
    end
  end

  describe 'PUT update' do
    before do
      @asset = stub_asset(permalink: 'bank')
      @snapshot = stub_asset_snapshot(permalink: 'bank-july-2010', asset: @asset)
    end

    context 'when logged in' do
      before do
        controller.login
        expect(AssetSnapshot).to receive(:find_by_permalink).and_return(@snapshot)
      end

      describe 'with valid params' do
        it 'redirects to the snapshot' do
          expect(@snapshot).to receive(:update_attributes).and_return(true)

          put :update, id: @snapshot.to_param, asset_snapshot: {}

          expect(response).to redirect_to @snapshot
          expect(flash[:success]).to match /updated/i
        end
      end

      describe 'with invalid params' do
        it "renders the 'edit' template" do
          expect(@snapshot).to receive(:update_attributes).and_return(false)

          put :update, id: @snapshot.to_param, asset_snapshot: {}

          expect(response).to render_template :edit
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        put :update, id: @snapshot.to_param, asset_snapshot: {}

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match /must be logged in/i
      end
    end
  end

  describe 'DELETE destroy' do
    before do
      @asset = stub_asset(permalink: 'bank')
      @snapshot = stub_asset_snapshot(permalink: 'bank-july-2010', asset: @asset)
    end

    context 'when logged in' do
      it 'destroys the requested snapshot and redirects to its asset' do
        controller.login
        expect(AssetSnapshot).to receive(:find_by_permalink).and_return(@snapshot)
        expect(@snapshot).to receive(:destroy).and_return(true)

        delete :destroy, id: @snapshot.to_param

        expect(response).to redirect_to @asset
        expect(flash[:success]).to match /deleted/i
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        delete :destroy, id: @snapshot.to_param

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match /must be logged in/i
      end
    end
  end
end
