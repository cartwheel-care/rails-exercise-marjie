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
end
