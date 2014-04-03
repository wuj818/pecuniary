require 'spec_helper'

describe ContributionsController do
  describe 'GET index' do
    it 'assigns all contributions as @contributions' do
      Contribution.should_receive(:includes).with(:asset).and_return(mock_relation)
      mock_relation.should_receive(:order).with('date DESC').and_return(mock_relation)

      get :index

      response.should render_template :index
      assigns(:contributions).should == mock_relation
    end
  end

  describe 'GET show' do
    it 'assigns the requested contribution as @contribution and its asset as @asset' do
      contribution = stub_contribution(permalink: 'bank-july-28-2010')
      Contribution.should_receive(:find_by_permalink).and_return(contribution)

      get :show, id: contribution.to_param

      response.should render_template :show
      assigns(:contribution).should == contribution
      assigns(:asset).should == contribution.asset
    end
  end

  describe 'GET new' do
    before do
      @asset = stub_asset(permalink: 'bank')
    end

    context 'when logged in' do
      it 'assigns a new contribution as @contribution' do
        controller.login
        FinancialAsset.should_receive(:find_by_permalink).and_return(@asset)
        @asset.contributions.should_receive(:build).and_return(stub_contribution(new_record?: true, asset: @asset))

        get :new, financial_asset_id: @asset.to_param

        response.should render_template :new
        assigns(:contribution).should be_a_new Contribution
        assigns(:contribution).asset.should == @asset
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get :new, financial_asset_id: @asset.to_param

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
      end
    end
  end

  describe 'POST create' do
    before do
      @asset = stub_asset(permalink: 'bank')
    end

    context 'when logged in' do
      before do
        controller.login
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

    context 'when logged out' do
      it 'redirects to the login page' do
        post :create, financial_asset_id: @asset.to_param, contribution: {}

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
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
        Contribution.should_receive(:find_by_permalink).and_return(@contribution)

        get :edit, id: @contribution.to_param

        response.should render_template :edit
        assigns(:contribution).should == @contribution
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get :edit, id: @contribution.to_param

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
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

    context 'when logged out' do
      it 'redirects to the login page' do
        put :update, id: @contribution.to_param, contribution: {}

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
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
        Contribution.should_receive(:find_by_permalink).and_return(@contribution)
        @contribution.should_receive(:destroy).and_return(true)

        delete :destroy, id: @contribution.to_param

        response.should redirect_to @asset
        flash[:success].should match /deleted/i
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        delete :destroy, id: @contribution.to_param

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
      end
    end
  end
end
