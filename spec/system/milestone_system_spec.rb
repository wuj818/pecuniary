# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Milestone System" do
  context "when logged in" do
    before { system_spec_login }

    describe "milestones index" do
      let!(:milestones) { create_list :milestone, 2 }

      it "lists the milestones along with edit and delete links" do
        visit milestones_path

        milestones.each do |milestone|
          expect(page).to have_link href: milestone_path(milestone)
          expect(page).to have_link href: edit_milestone_path(milestone)
          expect(page).to have_link id: dom_id(milestone, :delete)
        end
      end
    end

    describe "milestone creation" do
      let(:milestone_note) { "test note" }

      it "allows the admin to create milestones and shows errors when appropriate" do
        visit milestones_path
        click_link href: new_milestone_path
        click_button "Save"

        expect(page).to have_content(/prohibited this milestone from being saved/i)

        fill_in "milestone_notes", with: milestone_note
        click_button "Save"

        expect(page.current_path).to eq milestones_path
        expect(page).to have_content(/successfully created/i)
        expect(page).to have_content milestone_note
      end
    end

    describe "milestone modification" do
      let(:milestone_note) { "test note" }
      let(:new_milestone_note) { "new test note" }

      let!(:milestone) { create :milestone, notes: milestone_note }

      it "allows the admin to update milestones and shows errors when appropriate" do
        visit milestones_path
        click_link href: edit_milestone_path(milestone)

        fill_in "milestone_notes", with: ""
        click_button "Save"

        expect(page).to have_content(/prohibited this milestone from being saved/i)

        fill_in "milestone_notes", with: new_milestone_note
        click_button "Save"

        expect(page.current_path).to eq milestone_path(milestone)
        expect(page).to have_content(/successfully updated/i)
        expect(page).to have_content new_milestone_note
      end
    end

    describe "milestone deletion" do
      let!(:milestone) { create :milestone }

      it "deletes the milestone", js: true do
        visit milestones_path

        accept_confirm do
          click_link id: dom_id(milestone, :delete)
        end

        expect(page.current_path).to eq milestones_path
        expect(page).to have_content(/successfully deleted/i)
        expect(page).to have_no_link href: milestone_path(milestone)
      end
    end
  end

  context "when logged out" do
    describe "milestones index" do
      let!(:milestones) { create_list :milestone, 2 }

      it "lists the milestones without edit or delete links" do
        visit milestones_path

        milestones.each do |milestone|
          expect(page).to have_link href: milestone_path(milestone)
          expect(page).to have_no_link href: edit_milestone_path(milestone)
          expect(page).to have_no_link id: dom_id(milestone, :delete)
        end
      end
    end

    describe "milestone creation and modification" do
      let!(:milestone) { create :milestone }

      it "prevents access to the new and edit milestone pages" do
        visit new_milestone_path

        expect(page).to have_content(/must be logged in/i)

        visit edit_milestone_path(milestone)

        expect(page).to have_content(/must be logged in/i)
      end
    end
  end
end
