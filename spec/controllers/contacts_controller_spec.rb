require "rails_helper"

RSpec.describe ContactsController, type: :controller do
  describe "#index" do
    it "succeeds" do
      get :index

      expect(response.status).to eq 200
    end
  end

  describe "#create_patient" do
    let(:contact) { FactoryBot.create(:contact) }

    it "creates the patient for the contact and redirects" do
      patch :create_patient, params: { id: contact.id }

      expect(contact.reload.patient).to be_present
      expect(response.status).to eq 302
    end
  end
end
