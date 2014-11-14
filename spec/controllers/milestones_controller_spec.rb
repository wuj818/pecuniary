require 'rails_helper'

RSpec.describe MilestonesController do
  describe 'GET index' do
    it 'assigns all milestones as @milestones' do
      expect(Milestone).to receive(:order).with('date DESC').and_return(mock_relation)

      get :index

      expect(response).to render_template :index
      expect(assigns(:milestones)).to eq(mock_relation)
    end
  end

  describe 'GET show' do
    it 'assigns the requested milestone as @milestone' do
      milestone = stub_milestone(permalink: 'july-28-2010')
      expect(Milestone).to receive(:find_by_permalink).and_return(milestone)

      get :show, id: milestone.to_param

      expect(response).to render_template :show
      expect(assigns(:milestone)).to eq(milestone)
    end
  end

  describe 'GET new' do
    context 'when logged in' do
      it 'assigns a new milestone as @milestone' do
        controller.login

        get :new

        expect(response).to render_template :new
        expect(assigns(:milestone)).to be_a_new Milestone
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get :new

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match /must be logged in/i
      end
    end
  end

  describe 'POST create' do
    context 'when logged in' do
      before do
        controller.login
        @milestone = stub_milestone
        expect(Milestone).to receive(:new).and_return(@milestone)
      end

      describe 'with valid params' do
        it 'creates a new milestone and redirects to the milestones list' do
          expect(@milestone).to receive(:save).and_return(true)

          post :create, milestone: {}

          expect(response).to redirect_to milestones_path
          expect(flash[:success]).to match /created/i
        end
      end

      describe 'with invalid params' do
        it "renders the 'new' template" do
          expect(@milestone).to receive(:save).and_return(false)

          post :create, milestone: {}

          expect(response).to render_template :new
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        post :create, milestone: {}

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match /must be logged in/i
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
        expect(Milestone).to receive(:find_by_permalink).and_return(@milestone)

        get :edit, id: @milestone.to_param

        expect(response).to render_template :edit
        expect(assigns(:milestone)).to eq(@milestone)
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get :edit, id: @milestone.to_param

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match /must be logged in/i
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
        expect(Milestone).to receive(:find_by_permalink).and_return(@milestone)
      end

      describe 'with valid params' do
        it 'redirects to the milestone' do
          expect(@milestone).to receive(:update_attributes).and_return(true)

          put :update, id: @milestone.to_param, milestone: {}

          expect(response).to redirect_to @milestone
          expect(flash[:success]).to match /updated/i
        end
      end

      describe 'with invalid params' do
        it "renders the 'edit' template" do
          expect(@milestone).to receive(:update_attributes).and_return(false)

          put :update, id: @milestone.to_param, milestone: {}

          expect(response).to render_template :edit
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        put :update, id: @milestone.to_param, milestone: {}

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match /must be logged in/i
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
        expect(Milestone).to receive(:find_by_permalink).and_return(@milestone)
        expect(@milestone).to receive(:destroy).and_return(true)

        delete :destroy, id: @milestone.to_param

        expect(response).to redirect_to milestones_path
        expect(flash[:success]).to match /deleted/i
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        delete :destroy, id: @milestone.to_param

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match /must be logged in/i
      end
    end
  end
end

