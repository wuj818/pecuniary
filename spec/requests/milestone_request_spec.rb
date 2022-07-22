# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/milestones" do
  describe "GET /index" do
    it "returns a successful response" do
      get milestones_url

      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    let(:milestone) { create(:milestone) }

    it "returns a successful response" do
      get milestone_url(milestone)

      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    let(:request!) { get new_milestone_url }

    context "when logged in" do
      it "returns a successful response" do
        request_spec_login

        request!

        expect(response).to be_successful
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        request!

        expect(response).to redirect_to(login_url)
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe "POST /create" do
    let(:request!) { post milestones_url, params: params }

    let(:params) { { milestone: milestone_params } }
    let(:milestone_params) { nil }

    context "when logged in" do
      before { request_spec_login }

      describe "with valid params" do
        let(:milestone_params) { attributes_for(:milestone) }

        it "creates a new milestone and redirects to the milestones index" do
          expect { request! }.to change(Milestone, :count).by(1)

          expect(response).to redirect_to(milestones_url)
          expect(flash[:success]).to match(/created/i)
        end
      end

      describe "with invalid params" do
        let(:milestone_params) { attributes_for(:invalid_milestone) }

        it "doesn't create a new milestone" do
          expect { request! }.not_to change(Milestone, :count)

          expect(response).to be_successful
        end
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        request!

        expect(response).to redirect_to(login_url)
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe "GET /edit" do
    let(:milestone) { create(:milestone) }

    let(:request!) { get edit_milestone_url(milestone) }

    context "when logged in" do
      it "returns a successful response" do
        request_spec_login

        request!

        expect(response).to be_successful
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        request!

        expect(response).to redirect_to(login_url)
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe "PATCH /update" do
    let!(:milestone) { create(:milestone) }

    let(:request!) do
      patch milestone_url(milestone), params: params
      milestone.reload
    end

    let(:params) { { milestone: milestone_params } }
    let(:milestone_params) { nil }

    context "when logged in" do
      before { request_spec_login }

      describe "with valid params" do
        let(:new_notes) { milestone.notes.reverse }

        let(:milestone_params) { { notes: new_notes } }

        it "redirects to the milestone" do
          expect { request! }.to change(milestone, :notes).to(new_notes)

          expect(response).to redirect_to(milestone)
          expect(flash[:success]).to match(/updated/i)
        end
      end

      describe "with invalid params" do
        let(:milestone_params) { attributes_for(:invalid_milestone) }

        it "doesn't update the milestone" do
          expect { request! }.not_to change(milestone.reload, :attributes)

          expect(response).to be_successful
        end
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        request!

        expect(response).to redirect_to(login_url)
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:milestone) { create(:milestone) }

    let(:request!) { delete milestone_url(milestone) }

    context "when logged in" do
      it "destroys the requested milestone and redirects to the milestones index" do
        request_spec_login

        expect { request! }.to change(Milestone, :count).by(-1)

        expect(response).to redirect_to(milestones_url)
        expect(flash[:success]).to match(/deleted/i)
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        request!

        expect(response).to redirect_to(login_url)
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end
end
