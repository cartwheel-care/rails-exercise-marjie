class Patient < ApplicationRecord
  has_one :contact, dependent: :nullify
end
