require "rails_helper"

RSpec.describe PatientsController, type: :controller do
  describe "#index" do
    it "succeeds" do
      get :index

      expect(response.status).to eq 200
    end
  end

  describe "#sync" do
    let(:patient) { FactoryBot.create(:patient) }

    before { allow(PatientSyncService).to receive(:new).and_call_original }

    it "calls the sync service and redirects" do
      put :sync, params: { id: patient.id }

      expect(PatientSyncService).to have_received(:new)
      expect(response.status).to eq 302
    end
  end
end
