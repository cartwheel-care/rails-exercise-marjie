class Contact < ApplicationRecord
  belongs_to :patient, optional: true

  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :patient, allow_nil: true
end
