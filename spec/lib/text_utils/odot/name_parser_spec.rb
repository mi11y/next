require 'rails_helper'

RSpec.describe TextUtils::Odot::NameParser do
  let(:oregon_origin_no_direction) {"[ORE99W|sign-ore99w.png]; at SW Durham Rd"}
  let(:oregon_origin_with_direction) {"[ORE217|sign-ore217.png] NB; Allen Blvd"}
  let(:interstate_origin_with_direction) {"[I-5|sign-i-5.png] NB; SW Iowa St"}
  let(:us_route_origin_with_direction) {"[US26|sign-us26.png] EB; Zoo Bridge"}
  let(:ambiguous_origin_no_direction) {"TV Hwy; SW Cornelius Pass Rd"}
  let(:washington_route_destination) {"SR14; via I-5 NB"}
  let(:test_origin) { oregon_origin_no_direction }
  subject { described_class.new(test_origin) }

  context 'when it is an oregon origin' do
    describe '#highway_type' do
      it 'returns Oregon' do
        expect(subject.highway_type).to eq("Oregon")
      end

      context 'when there is a direction indicator' do
        let(:test_origin) { oregon_origin_with_direction }

        it 'returns Oregon' do
          expect(subject.highway_type).to eq("Oregon")
        end
      end
    end

    describe '#name' do
      it 'removes the state name' do
        expect(subject.name).to eq("99W")
      end

      context 'when there is a direction indicator' do
        let(:test_origin) { oregon_origin_with_direction }

        it 'removes the state name' do
          expect(subject.name).to eq("217")
        end
      end
    end

    describe '#direction' do
      it 'returns an empty string' do
        expect(subject.direction).to eq("")
      end

      context 'when there is a direction indicator' do
        let(:test_origin) { oregon_origin_with_direction }

        it 'returns the direction' do
          expect(subject.direction).to eq("NB")
        end
      end
    end

    describe '#cross_street' do
      it 'returns the cross street' do
        expect(subject.cross_street).to eq("at SW Durham Rd")
      end

      context 'when there is a direction indicator' do
        let(:test_origin) { oregon_origin_with_direction }

        it 'returns the cross street' do
          expect(subject.cross_street).to eq("Allen Blvd")
        end
      end
    end
  end

  context 'when it is an interstate origin' do
    let(:test_origin) { interstate_origin_with_direction }

    describe '#highway_type' do
      it 'returns Interstate' do
        expect(subject.highway_type).to eq("Interstate")
      end
    end

    describe '#name' do
      it 'removes interstate symbol' do
        expect(subject.name).to eq("5")
      end
    end

    describe '#direction' do
      it 'returns the direction' do
        expect(subject.direction).to eq("NB")
      end
    end

    describe '#cross_street' do
      it 'returns the cross street' do
        expect(subject.cross_street).to eq("SW Iowa St")
      end
    end
  end

  context 'when it is a US route origin' do
    let(:test_origin) { us_route_origin_with_direction }
    describe '#highway_type' do
      it 'returns US' do
        expect(subject.highway_type).to eq("US")
      end
    end

    describe '#name' do
      it 'removes US symbol' do
        expect(subject.name).to eq("26")
      end
    end

    describe '#direction' do
      it 'returns the direction' do
        expect(subject.direction).to eq("EB")
      end
    end

    describe '#cross_street' do
      it 'returns the cross street' do
        expect(subject.cross_street).to eq("Zoo Bridge")
      end
    end
  end

  context 'when it is a Washigton SR route destination' do
    let(:test_origin) { washington_route_destination }
    describe '#highway_type' do
      it 'returns SR' do
        expect(subject.highway_type).to eq("SR")
      end
    end

    describe '#name' do
      it 'removes SR symbol' do
        expect(subject.name).to eq("14")
      end
    end

    describe '#direction' do
      it 'returns the empty string' do
        expect(subject.direction).to eq("")
      end
    end

    describe '#cross_street' do
      it 'returns the cross street' do
        expect(subject.cross_street).to eq("via I-5 NB")
      end
    end
  end

  context 'when the origin is ambiguous' do
    let(:test_origin) { ambiguous_origin_no_direction }
    describe '#highway_type' do
      it 'returns Oregon' do
        expect(subject.highway_type).to eq("Road")
      end
    end

    describe '#name' do
      it 'returns the whole name' do
        expect(subject.name).to eq("TV Hwy")
      end
    end

    describe '#direction' do
      it 'returns the empty string' do
        expect(subject.direction).to eq("")
      end
    end

    describe '#cross_street' do
      it 'returns the cross street' do
        expect(subject.cross_street).to eq("SW Cornelius Pass Rd")
      end
    end
  end
end