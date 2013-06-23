class ContributionsController < ApplicationController
  before_filter :get_asset, only: [:new, :create]
  before_filter :get_contribution, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @contribution = @asset.contributions.build
  end

  def edit
  end

  def create
    @contribution = @asset.contributions.build params[:contribution]

    if @contribution.save
      flash[:success] = 'Contribution was successfully created.'
      redirect_to @asset
    else
      render :new
    end
  end

  def update
    if @contribution.update_attributes params[:contribution]
      flash[:success] = 'Contribution was successfully updated.'
      redirect_to @contribution
    else
      render :edit
    end
  end

  def destroy
    @contribution.destroy

    flash[:success] = 'Contribution was successfully deleted.'
    redirect_to @asset
  end

  private

  def get_asset
    @asset = FinancialAsset.find_by_permalink params[:financial_asset_id]
  end

  def get_contribution
    @contribution = Contribution.find_by_permalink params[:id]
    @asset = @contribution.asset
  end
end
