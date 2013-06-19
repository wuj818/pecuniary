class FinancialAssetsController < ApplicationController
  before_filter :get_asset, only: [:show, :edit, :update, :destroy]

  def index
    @assets = FinancialAsset.order(:name)
  end

  def show
  end

  def new
    @asset = FinancialAsset.new
  end

  def edit
  end

  def create
    @asset = FinancialAsset.new params[:financial_asset]

    if @asset.save
      flash[:notice] = 'Asset was successfully created.'
      redirect_to financial_assets_path
    else
      render :new
    end
  end

  def update
    if @asset.update_attributes params[:financial_asset]
      flash[:notice] = 'Asset was successfully updated.'
      redirect_to @asset
    else
      render :edit
    end
  end

  def destroy
    @asset.destroy

    flash[:notice] = 'Asset was successfully deleted.'
    redirect_to financial_assets_path
  end

  private

  def get_asset
    @asset = FinancialAsset.find_by_permalink params[:id]
  end
end
