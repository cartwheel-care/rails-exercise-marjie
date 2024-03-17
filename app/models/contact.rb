class Contact < ApplicationRecord
  AVATAR_URL = "https://robohash.org/quitotamnon.png?size=300x300&set=set1".freeze

  belongs_to :patient, optional: true

  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :patient, allow_nil: true

  def create_patient!
    return if patient

    ActiveRecord::Base.transaction do
      patient = Patient.create!(
        first_name: first_name,
        last_name: last_name,
        avatar_url: AVATAR_URL,
      )

      update!(patient: patient)
    end
  end
end
