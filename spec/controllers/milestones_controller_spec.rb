require 'rails_helper'

RSpec.describe MilestonesController do
  describe 'GET index' do
    it 'assigns all milestones as @milestones' do
      Milestone.should_receive(:order).with('date DESC').and_return(mock_relation)

      get :index

      response.should render_template :index
      assigns(:milestones).should == mock_relation
    end
  end

  describe 'GET show' do
    it 'assigns the requested milestone as @milestone' do
      milestone = stub_milestone(permalink: 'july-28-2010')
      Milestone.should_receive(:find_by_permalink).and_return(milestone)

      get :show, id: milestone.to_param

      response.should render_template :show
      assigns(:milestone).should == milestone
    end
  end

  describe 'GET new' do
    context 'when logged in' do
      it 'assigns a new milestone as @milestone' do
        controller.login

        get :new

        response.should render_template :new
        assigns(:milestone).should be_a_new Milestone
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get :new

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
      end
    end
  end

  describe 'POST create' do
    context 'when logged in' do
      before do
        controller.login
      end

      describe 'with valid params' do
        it 'creates a new milestone and redirects to the milestones list' do
          Milestone.any_instance.should_receive(:save).and_return(true)

          post :create, milestone: {}

          response.should redirect_to milestones_path
          flash[:success].should match /created/i
        end
      end

      describe 'with invalid params' do
        it "renders the 'new' template" do
          Milestone.any_instance.should_receive(:save).and_return(false)

          post :create, milestone: {}

          response.should render_template :new
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        post :create, milestone: {}

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
      end
    end
  end

  describe 'GET edit' do
    before do
      @milestone = stub_milestone(permalink: 'july-28-2010')
    end

    context 'when logged in' do
      it 'assigns the requested milestone as @milestone' do
        controller.login
        Milestone.should_receive(:find_by_permalink).and_return(@milestone)

        get :edit, id: @milestone.to_param

        response.should render_template :edit
        assigns(:milestone).should == @milestone
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get :edit, id: @milestone.to_param

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
      end
    end
  end

  describe 'PUT update' do
    before do
      @milestone = stub_milestone(permalink: 'july-28-2010')
    end

    context 'when logged in' do
      before do
        controller.login
        Milestone.should_receive(:find_by_permalink).and_return(@milestone)
      end

      describe 'with valid params' do
        it 'redirects to the milestone' do
          @milestone.should_receive(:update_attributes).and_return(true)

          put :update, id: @milestone.to_param, milestone: {}

          response.should redirect_to @milestone
          flash[:success].should match /updated/i
        end
      end

      describe 'with invalid params' do
        it "renders the 'edit' template" do
          @milestone.should_receive(:update_attributes).and_return(false)

          put :update, id: @milestone.to_param, milestone: {}

          response.should render_template :edit
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        put :update, id: @milestone.to_param, milestone: {}

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
      end
    end
  end

  describe 'DELETE destroy' do
    before do
      @milestone = stub_milestone(permalink: 'july-28-2010')
    end

    context 'when logged in' do
      it 'destroys the requested milestone and redirects to the milestones list' do
        controller.login
        Milestone.should_receive(:find_by_permalink).and_return(@milestone)
        @milestone.should_receive(:destroy).and_return(true)

        delete :destroy, id: @milestone.to_param

        response.should redirect_to milestones_path
        flash[:success].should match /deleted/i
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        delete :destroy, id: @milestone.to_param

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
      end
    end
  end
end

