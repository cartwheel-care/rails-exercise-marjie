class PatientsController < ApplicationController
  include FlashHelper

  def index
    @patients = Patient.all.order(:first_name, :last_name)
  end

  def sync
    @patient = Patient.find(params[:id])

    sync_result = PatientSyncService.new(@patient).sync

    set_sicklie_sync_flash(sync_result: sync_result, patient: @patient)

    redirect_to action: :index
  end
end
