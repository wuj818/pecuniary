require 'rails_helper'

RSpec.describe 'Milestones' do
  describe 'GET index' do
    it 'returns a successful response' do
      expect(Milestone).to receive(:order).with('date DESC').and_return mock_relation

      get milestones_path

      expect(response).to have_http_status :ok
    end
  end

  describe 'GET show' do
    it 'returns a successful response' do
      milestone = stub_milestone permalink: 'july-28-2010'
      expect(Milestone).to receive(:find_by).with(permalink: milestone.to_param).and_return milestone

      get milestone_path(milestone)

      expect(response).to have_http_status :ok
    end
  end

  describe 'GET new' do
    context 'when logged in' do
      it 'returns a successful response' do
        request_spec_login

        get new_milestone_path

        expect(response).to have_http_status :ok
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get new_milestone_path

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'POST create' do
    context 'when logged in' do
      let(:milestone) { stub_milestone }

      before do
        request_spec_login
        expect(Milestone).to receive(:new).and_return milestone
      end

      describe 'with valid params' do
        it 'creates a new milestone and redirects to the milestones index' do
          expect(milestone).to receive(:save).and_return true

          post milestones_path, params: { milestone: { test: 1 } }

          expect(response).to redirect_to milestones_path
          expect(flash[:success]).to match(/created/i)
        end
      end

      describe 'with invalid params' do
        it "doesn't create a new milestone" do
          expect(milestone.as_new_record).to receive(:save).and_return false

          post milestones_path, params: { milestone: { test: 1 } }

          expect(response).to have_http_status :ok
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        expect(Milestone).not_to receive(:new)

        post milestones_path, params: { milestone: { test: 1 } }

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'GET edit' do
    let(:milestone) { stub_milestone permalink: 'july-28-2010' }

    context 'when logged in' do
      it 'returns a successful response' do
        request_spec_login
        expect(Milestone).to receive(:find_by).with(permalink: milestone.to_param).and_return milestone

        get edit_milestone_path(milestone)

        expect(response).to have_http_status :ok
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        expect(Milestone).not_to receive(:find_by)

        get edit_milestone_path(milestone)

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'PATCH update' do
    let(:milestone) { stub_milestone permalink: 'july-28-2010' }

    context 'when logged in' do
      before do
        request_spec_login
        expect(Milestone).to receive(:find_by).with(permalink: milestone.to_param).and_return milestone
      end

      describe 'with valid params' do
        it 'redirects to the milestone' do
          expect(milestone).to receive(:update).and_return true

          patch milestone_path(milestone, milestone: { test: 1 })

          expect(response).to redirect_to milestone
          expect(flash[:success]).to match(/updated/i)
        end
      end

      describe 'with invalid params' do
        it "doesn't update the milestone" do
          expect(milestone).to receive(:update).and_return false

          patch milestone_path(milestone, milestone: { test: 1 })

          expect(response).to have_http_status :ok
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        expect(Milestone).not_to receive(:find_by)

        patch milestone_path(milestone, milestone: { test: 1 })

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'DELETE destroy' do
    let(:milestone) { stub_milestone permalink: 'july-28-2010' }

    context 'when logged in' do
      it 'destroys the requested milestone and redirects to the milestones index' do
        request_spec_login
        expect(Milestone).to receive(:find_by).with(permalink: milestone.to_param).and_return milestone
        expect(milestone).to receive(:destroy).and_return true

        delete milestone_path(milestone)

        expect(response).to redirect_to milestones_path
        expect(flash[:success]).to match(/deleted/i)
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        expect(Milestone).not_to receive(:find_by)

        delete milestone_path(milestone)

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end
end
