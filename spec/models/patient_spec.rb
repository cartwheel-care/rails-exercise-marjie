require 'rails_helper'

RSpec.describe Patient, type: :model do
  it { is_expected.to have_one(:contact) }
end
