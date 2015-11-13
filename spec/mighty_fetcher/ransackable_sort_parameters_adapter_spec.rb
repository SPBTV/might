require 'mighty_fetcher/ransackable_sort_parameters_adapter'
require 'mighty_fetcher/sort_parameter'
require 'mighty_fetcher/sort_parameter_definition'

RSpec.describe MightyFetcher::RansackableSortParametersAdapter do
  let(:converter) do
    described_class.new(->(env) { env[1] })
  end

  subject { converter.call([nil, [parameter]]) }

  context 'with normal direction' do
    let(:definition) { MightyFetcher::SortParameterDefinition.new(:name) }
    let(:parameter) { MightyFetcher::SortParameter.new('asc', definition) }

    it 'generate ransackable sort parameters' do
      is_expected.to eq(['name asc'])
    end
  end

  context 'with reversed direction' do
    let(:definition) { MightyFetcher::SortParameterDefinition.new(:name, reverse_direction: true) }
    let(:parameter) { MightyFetcher::SortParameter.new('desc', definition) }

    it 'generate ransackable sort parameters' do
      is_expected.to eq(['name asc'])
    end
  end
end
