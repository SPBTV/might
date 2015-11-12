require 'mighty_fetcher/sort/ransackable/parameters_converter'
require 'mighty_fetcher/sort/parameter'
require 'mighty_fetcher/sort/parameter_definition'

RSpec.describe MightyFetcher::Sort::Ransackable::ParametersConverter do
  let(:converter) do
    described_class.new(->(env) { env[1] })
  end

  subject { converter.call([nil, [parameter]]) }

  context 'with normal direction' do
    let(:definition) { MightyFetcher::Sort::ParameterDefinition.new(:name) }
    let(:parameter) { MightyFetcher::Sort::Parameter.new('asc', definition) }

    it 'generate ransackable sort parameters' do
      is_expected.to eq(['name asc'])
    end
  end

  context 'with reversed direction' do
    let(:definition) { MightyFetcher::Sort::ParameterDefinition.new(:name, reverse_direction: true) }
    let(:parameter) { MightyFetcher::Sort::Parameter.new('desc', definition) }

    it 'generate ransackable sort parameters' do
      is_expected.to eq(['name asc'])
    end
  end
end
