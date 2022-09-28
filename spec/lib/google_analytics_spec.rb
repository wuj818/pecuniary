# frozen_string_literal: true

require "rails_helper"

RSpec.describe GoogleAnalytics do
  let(:valid_measurement_id) { "G4-web-stream-measurement-id" }

  let(:blank_ids) { [nil, "", " "] }

  describe ".web_stream_measurement_id" do
    def stub_measurement_id_env_var(id)
      stub_env(GA4_MEASUREMENT_ID: id)
    end

    context "when the measurement ID env variable is not set" do
      it "is expected to be blank", :aggregate_failures do
        blank_ids.each do |blank_id|
          stub_measurement_id_env_var(blank_id)

          expect(described_class.measurement_id).to be_blank
        end
      end
    end

    context "when the measurement ID env variable is set" do
      subject { described_class.measurement_id }

      before { stub_measurement_id_env_var(valid_measurement_id) }

      it { is_expected.to eq(valid_measurement_id) }
    end
  end

  describe ".enabled?" do
    def stub_measurement_id(id)
      allow(described_class)
        .to receive(:measurement_id)
        .and_return(id)
    end

    context "when the web stream measurement ID is missing" do
      it "is expected to equal false", :aggregate_failures do
        blank_ids.each do |blank_id|
          stub_measurement_id(blank_id)

          expect(described_class.enabled?).to be(false)
        end
      end
    end

    context "when the web stream measurement ID is present" do
      subject { described_class.enabled? }

      before do
        allow(described_class)
          .to receive(:measurement_id)
          .and_return(valid_measurement_id)
      end

      it { is_expected.to be(true) }
    end
  end
end
