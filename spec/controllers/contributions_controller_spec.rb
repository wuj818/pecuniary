require 'spec_helper'

describe ContributionsController do
  describe 'GET show' do
    it 'assigns the requested contribution as @contribution and its asset as @asset' do
      contribution = stub_contribution(permalink: 'bank-july-2010')
      Contribution.should_receive(:find_by_permalink).and_return(contribution)

      get :show, id: contribution.to_param

      response.should render_template :show
      assigns(:contribution).should == contribution
      assigns(:asset).should == contribution.asset
    end
  end

  describe 'GET new' do
    it 'assigns a new contribution as @contribution' do
      asset = stub_asset(permalink: 'bank')
      FinancialAsset.should_receive(:find_by_permalink).and_return(asset)
      asset.contributions.should_receive(:build).and_return(stub_contribution(new_record?: true, asset: asset))

      get :new, financial_asset_id: asset.to_param

      response.should render_template :new
      assigns(:contribution).should be_a_new Contribution
      assigns(:contribution).asset.should == asset
    end
  end

  describe 'POST create' do
    before do
      @asset = stub_asset(permalink: 'bank')
      FinancialAsset.should_receive(:find_by_permalink).and_return(@asset)
      @asset.contributions.should_receive(:build).and_return(stub_contribution(new_record?: true, asset: @asset))
    end

    describe 'with valid params' do
      it 'creates a new contribution and redirects to its asset' do
        Contribution.any_instance.should_receive(:save).and_return(true)

        post :create, financial_asset_id: @asset.to_param, contribution: {}

        response.should redirect_to @asset
        flash[:success].should match /created/i
      end
    end

    describe 'with invalid params' do
      it "renders the 'new' template" do
        Contribution.any_instance.should_receive(:save).and_return(false)

        post :create, financial_asset_id: @asset.to_param, contribution: {}

        response.should render_template :new
      end
    end
  end

  describe 'PUT update' do
    before do
      @asset = stub_asset(permalink: 'bank')
      @contribution = stub_contribution(permalink: 'july-2010', asset: @asset)
      Contribution.should_receive(:find_by_permalink).and_return(@contribution)
    end

    describe 'with valid params' do
      it 'redirects to the contribution' do
        @contribution.should_receive(:update_attributes).and_return(true)

        put :update, id: @contribution.to_param, contribution: {}

        response.should redirect_to @contribution
        flash[:success].should match /updated/i
      end
    end

    describe 'with invalid params' do
      it "renders the 'edit' template" do
        @contribution.should_receive(:update_attributes).and_return(false)

        put :update, id: @contribution.to_param, contribution: {}

        response.should render_template :edit
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested contribution and redirects to its asset' do
      asset = stub_asset(permalink: 'bank')
      contribution = stub_contribution(permalink: 'july-2010', asset: asset)
      Contribution.should_receive(:find_by_permalink).and_return(contribution)
      contribution.should_receive(:destroy).and_return(true)

      delete :destroy, id: contribution.to_param

      response.should redirect_to asset
      flash[:success].should match /deleted/i
    end
  end
end
