# frozen_string_literal: true
RSpec.describe Might::RansackableSortParametersAdapter do
  let(:converter) do
    described_class.new(->(env) { env[1] })
  end

  subject { converter.call([nil, { sort: [parameter] }])[:sort] }

  context 'with normal direction' do
    let(:definition) { Might::SortParameterDefinition.new(:name) }
    let(:parameter) { Might::SortParameter.new('asc', definition) }

    it 'generate ransackable sort parameters' do
      is_expected.to eq(['name asc'])
    end
  end

  context 'with reversed direction' do
    let(:definition) { Might::SortParameterDefinition.new(:name, reverse_direction: true) }
    let(:parameter) { Might::SortParameter.new('desc', definition) }

    it 'generate ransackable sort parameters' do
      is_expected.to eq(['name asc'])
    end
  end
end
