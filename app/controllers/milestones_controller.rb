class MilestonesController < ApplicationController
  before_filter :authorize, only: [:new, :create, :edit, :update, :destroy]

  before_filter :get_milestone, only: [:show, :edit, :update, :destroy]

  def index
    @milestones = Milestone.order('date DESC')
  end

  def show
  end

  def new
    @milestone = Milestone.new
  end

  def create
    @milestone = Milestone.new params[:milestone]

    if @milestone.save
      flash[:success] = 'Milestone was successfully created.'
      redirect_to @milestone
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @milestone.update_attributes params[:milestone]
      flash[:success] = 'Milestone was successfully updated.'
      redirect_to @milestone
    else
      render :edit
    end
  end

  def destroy
    @milestone.destroy

    flash[:success] = 'Milestone was successfully deleted.'
    redirect_to milestones_path
  end

  private

  def get_milestone
    @milestone = Milestone.find_by_permalink params[:id]
  end
end
