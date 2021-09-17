require 'rails_helper'

RSpec.describe Brand, type: :model do
  describe 'validations' do
    subject { described_class.new }

    it { should validate_presence_of(:name) }
  end
end
