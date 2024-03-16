class PatientSyncService
  def initialize(patient)
    @patient = patient
  end

  def sync
    if @patient.sicklie_id.blank?
      result = SicklieApi.create_patient(
        first_name: @patient.first_name, 
        last_name: @patient.last_name
      )

      if result.is_a?(Hash) && result[:status_code] == "SUCCESS"
        @patient.update!(
          sicklie_id: result[:sicklie_id],
          sicklie_updated_at: Time.current
        )
      end
    else
      result = SicklieApi.update_patient(
        sicklie_id: @patient.sicklie_id, 
        first_name: @patient.first_name, 
        last_name: @patient.last_name
      )
      if result.is_a?(Hash) && result[:status_code] == "SUCCESS"
        @patient.update!(sicklie_updated_at: Time.current)
      end      
    end

    result
  end
end