require "rails_helper"

RSpec.describe Contact, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:patient).optional }
  end

  describe "validations" do
    let(:subject) { FactoryBot.build(:contact, :with_patient) }

    it { is_expected.to validate_uniqueness_of(:patient).allow_nil }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
  end

  describe "create_patient!" do
    context "when the contact already has a patient attached" do
      let(:contact) { FactoryBot.create(:contact, :with_patient) }

      it "does nothing" do
        initial_patient_id = contact.patient_id

        expect { contact.create_patient! }.not_to change(Patient, :count)

        expect(contact.reload.patient_id).to eq initial_patient_id
      end
    end

    context "when the contact does not have a patient" do
      let(:contact) { FactoryBot.create(:contact) }

      it "creates and associates the patient" do
        expect { contact.create_patient! }.to change(Patient, :count).by(1)

        expect(contact.patient.first_name).to eq contact.first_name
        expect(contact.patient.last_name).to eq contact.last_name
        expect(contact.patient.avatar_url).to eq Contact::AVATAR_URL
      end
    end
  end
end
