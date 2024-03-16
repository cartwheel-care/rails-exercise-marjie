require "rails_helper"

RSpec.describe FlashHelper, type: :helper do
  describe "#set_sicklie_sync_flash" do
    let(:patient) { FactoryBot.create(:patient) }

    context 'when the sync_result is a string' do
      let(:sync_result) { "Internal server error" }

      it 'sets the flash message' do
        helper.set_sicklie_sync_flash(sync_result: sync_result, patient: patient)

        expect(flash[:danger]).to eq(
          "Something went wrong syncing patient '#{patient.first_name} #{patient.last_name}' with Sicklie. Internal server error"
        )
      end
    end

    context 'when the sync_result is an array of errors' do
      let(:sync_result) do
        [
          { status_code: "ERROR_1", message: "Message 1" },
          { status_code: "ERROR_2", message: "Message 2" },
        ]
      end

      it 'sets the flash message' do
        helper.set_sicklie_sync_flash(sync_result: sync_result, patient: patient)

        expect(flash[:danger]).to eq(
          "Something went wrong syncing patient '#{patient.first_name} #{patient.last_name}' with Sicklie. ERROR_1: Message 1; ERROR_2: Message 2"
        )
      end
    end

    context 'when the sync_result is a success' do
      let(:sync_result) { { status_code: "SUCCESS", sicklie_id: SecureRandom.uuid } }

      it 'sets the flash message' do
        helper.set_sicklie_sync_flash(sync_result: sync_result, patient: patient)

        expect(flash[:success]).to eq(
          "Success! Synced patient '#{patient.first_name} #{patient.last_name}' with Sicklie"
        )
      end
    end

    context 'when the sync_result is not parsable' do
      let(:sync_result) { { bad_data: "Uh oh" } }

      it 'sets the flash message' do
        helper.set_sicklie_sync_flash(sync_result: sync_result, patient: patient)

        expect(flash[:danger]).to eq "Something went wrong syncing patient '#{patient.first_name} #{patient.last_name}' with Sicklie. Unknown API error {:bad_data=>\"Uh oh\"}"
      end
    end
  end
end
