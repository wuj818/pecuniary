class MilestonesController < ApplicationController
  before_action :authorize, only: %i[new create edit update destroy]

  before_action :set_milestone, only: %i[show edit update destroy]

  def index
    @milestones = Milestone.order("date DESC")
  end

  def show; end

  def new
    @milestone = Milestone.new
  end

  def create
    @milestone = Milestone.new milestone_params

    if @milestone.save
      flash[:success] = "Milestone was successfully created."
      redirect_to milestones_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @milestone.update milestone_params
      flash[:success] = "Milestone was successfully updated."
      redirect_to @milestone
    else
      render :edit
    end
  end

  def destroy
    @milestone.destroy

    flash[:success] = "Milestone was successfully deleted."
    redirect_to milestones_path
  end

  private

  def milestone_params
    params.require(:milestone).permit :date, :notes, :permalink, :tag_list
  end

  def set_milestone
    @milestone = Milestone.find_by! permalink: params[:id]
  end
end
