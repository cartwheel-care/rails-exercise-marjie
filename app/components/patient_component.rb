class PatientComponent < ViewComponent::Base
  def initialize(patient:, origin_path:)
    @patient = patient
    @origin_path = origin_path
  end
end
