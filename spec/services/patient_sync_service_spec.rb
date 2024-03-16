require "rails_helper"

RSpec.describe PatientSyncService, type: :service do
  include ActiveSupport::Testing::TimeHelpers

  let(:instance) { described_class.new(patient) }
  let(:patient) { FactoryBot.create(:patient, sicklie_id: patient_sicklie_id) }

  describe "#sync" do
    subject(:call) { instance.sync }

    before { freeze_time }

    context "when the patient does NOT have a sicklie_id" do
      let(:patient_sicklie_id) { nil }

      before { allow(SicklieApi).to receive(:create_patient).and_return(api_response) }

      context "with a successful API response" do
        let(:api_response) do
          { status_code: "SUCCESS", sicklie_id: SecureRandom.uuid }
        end

        it "calls the sicklie API to create a patient and returns the result" do
          result = call
          expect(SicklieApi).to have_received(:create_patient).with(
            first_name: patient.first_name,
            last_name: patient.last_name,
          )
          expect(result[:status_code]).to eq "SUCCESS"
          expect(result[:sicklie_id]).to be_present
        end

        it "updates the patient record" do
          call
          expect(patient).to have_attributes(
            sicklie_id: api_response[:sicklie_id],
            sicklie_updated_at: Time.current          
          )
        end
      end

      context 'with a failing API response' do
        let(:api_response) { "Internal server error" }

        it "calls the sicklie API to create a patient and returns the result" do
          result = call
          expect(SicklieApi).to have_received(:create_patient).with(
            first_name: patient.first_name,
            last_name: patient.last_name,
          )
          expect(result).to eq "Internal server error"
        end

        it "does not update the patient record" do
          call
          expect(patient).to have_attributes(
            sicklie_id: nil,
            sicklie_updated_at: nil
          )
        end
      end
    end

    context "when the patient has a sicklie_id" do
      let(:patient_sicklie_id) { SecureRandom.uuid }

      before { allow(SicklieApi).to receive(:update_patient).and_return(api_response) }

      context "with a successful API response" do
        let(:api_response) do
          { status_code: "SUCCESS", sicklie_id: SecureRandom.uuid }
        end

        it "calls the sicklie API to update a patient" do
          result = call
          expect(SicklieApi).to have_received(:update_patient).with(
            sicklie_id: patient_sicklie_id,
            first_name: patient.first_name,
            last_name: patient.last_name,
          )
          expect(result[:status_code]).to eq "SUCCESS"
          expect(result[:sicklie_id]).to be_present
        end

        it "updates the patient record" do
          call
          expect(patient).to have_attributes(
            sicklie_updated_at: Time.current          
          )
        end
      end

      context 'with a failing API response' do
        let(:api_response) { "Internal server error" }

        it "calls the sicklie API to create a patient and returns the result" do
          result = call
          expect(SicklieApi).to have_received(:update_patient).with(
            sicklie_id: patient_sicklie_id,
            first_name: patient.first_name,
            last_name: patient.last_name,
          )
          expect(result).to eq "Internal server error"
        end

        it "does not update the patient record" do
          call
          expect(patient).to have_attributes(
            sicklie_id: patient_sicklie_id,
            sicklie_updated_at: nil
          )
        end
      end
    end    
  end
end