require 'rails_helper'

RSpec.describe Share, type: :model do
  let(:bike_1_uuid) { 'b5c8862a-f1b3-42a6-9757-ce905620b897' }
  let(:bike_1_lat) { '45.4577' }
  let(:bike_1_lon) { '-122.6045' }
  let(:bike_1_reserved) { 0 }
  let(:bike_1_disabled) { 0 }

  let(:sample_payload) {
    "{
      \"last_updated\": 1627140184,
      \"ttl\": 0,
      \"version\": \"1.0\",
      \"data\": {
          \"bikes\": [
              {
                  \"bike_id\": \"#{bike_1_uuid}\",
                  \"lat\": \"#{bike_1_lat}\",
                  \"lon\": \"#{bike_1_lon}\",
                  \"is_reserved\": #{bike_1_reserved},
                  \"is_disabled\": #{bike_1_disabled},
                  \"vehicle_type\": \"scooter\"
              },
              {
                  \"bike_id\": \"82375019-8772-400c-ac9d-a06a23dc3574\",
                  \"lat\": \"45.4577\",
                  \"lon\": \"-122.6045\",
                  \"is_reserved\": 0,
                  \"is_disabled\": 0,
                  \"vehicle_type\": \"scooter\"
              },
              {
                  \"bike_id\": \"3544bee0-a801-4ee7-9245-0317d7573372\",
                  \"lat\": \"45.4584\",
                  \"lon\": \"-122.6238\",
                  \"is_reserved\": 0,
                  \"is_disabled\": 0,
                  \"vehicle_type\": \"scooter\"
              }
          ]
      }
    }"
  }

  describe 'validations' do
    subject { described_class.new }

    it { should validate_presence_of(:lat) }
    it { should validate_presence_of(:lon) }
    it { should validate_presence_of(:bike_uuid) }
    it { should validate_presence_of(:disabled) }
    it { should validate_presence_of(:reserved) }
    it { should validate_presence_of(:brand) }
  end

  describe '.for' do
    subject { described_class }

    let(:brand) { Brand.find_by(name: 'Spin') }

    it 'can initialize from a JSON payload' do
      result = subject.for(sample_payload, brand)
      expect(result.first).to be_a described_class
    end

    it 'can initialize from a hash payload' do
      result = subject.for_hash(JSON.parse(sample_payload).with_indifferent_access, brand)
      expect(result.first).to be_a described_class
    end

    it 'persists bikes in the database' do
      subject.for(sample_payload, brand)
      expect(Share.find_by(bike_uuid: bike_1_uuid)).to_not be nil
    end

    it 'initializes to a default brand' do
      result = subject.for(sample_payload)
      expect(result.first.brand.name).to eq('Bird')
    end

    it 'sets the bike longitude' do
      result = subject.for(sample_payload, brand)
      expect(result.first.lon).to eq(bike_1_lon)
    end

    it 'sets the bike lattitude' do
      result = subject.for(sample_payload, brand)
      expect(result.first.lat).to eq(bike_1_lat)
    end

    it 'sets the bike UUID' do
      result = subject.for(sample_payload, brand)
      expect(result.first.bike_uuid).to eq(bike_1_uuid)
    end

    context 'when the bike is disabled' do
      let(:bike_1_disabled) { 1 }

      it 'sets the bike disability status' do
        result = subject.for(sample_payload, brand)
        expect(result.first.disabled).to eq(bike_1_disabled)
      end  
    end
    

    context 'when the bike is reserved' do
      let(:bike_1_reserved) { 1 }

      it 'sets the bike reservation status' do
        result = subject.for(sample_payload, brand)
        expect(result.first.reserved).to eq(bike_1_reserved)
      end
    end

    context 'when the bike already exists' do
      it 'does not create a new record' do 
        subject.for(sample_payload, brand)
        subject.for(sample_payload, brand)

        expect(Share.count).to eq(3)
      end
    end
  end
end
