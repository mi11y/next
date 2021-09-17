require 'rails_helper'

RSpec.describe Conductors::DataCleaner do
  subject { Conductors::DataCleaner.new }

  let(:query_double) { double('Query', count: 1, destroy_all: true)}

  it 'raises NotImplementedError when cleaner_name is not redefined' do
    allow(subject).to receive(:query).and_return(query_double)
    expect { subject.run }.to raise_error(NotImplementedError)
  end

  it 'raises NotImplementedError when query is not redefined' do
    allow(subject).to receive(:cleaner_name).and_return('Test')
    expect { subject.run }.to raise_error(NotImplementedError)
  end
end