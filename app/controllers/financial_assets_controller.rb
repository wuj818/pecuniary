class FinancialAssetsController < ApplicationController
  def index
    @assets = FinancialAsset.order(:name)
  end

  def show
    @asset = FinancialAsset.find params[:id]
  end

  def new
    @asset = FinancialAsset.new
  end

  def edit
    @asset = FinancialAsset.find params[:id]
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
    @asset = FinancialAsset.find params[:id]

    if @asset.update_attributes params[:financial_asset]
      flash[:notice] = 'Asset was successfully updated.'
      redirect_to @asset
    else
      render :edit
    end
  end

  def destroy
    @asset = FinancialAsset.find params[:id]
    @asset.destroy

    flash[:notice] = 'Asset was successfully deleted.'
    redirect_to financial_assets_path
  end
end
