require 'mighty_fetcher/filter/ransackable/parameters_converter'
require 'mighty_fetcher/filter/parameter'
require 'mighty_fetcher/filter/parameter_definition'

RSpec.describe MightyFetcher::Filter::Ransackable::ParametersConverter do
  let(:converter) do
    described_class.new(->(env) { env[1] })
  end

  subject { converter.call([nil, [parameter]]) }

  context 'on association' do
    let(:definition) { MightyFetcher::Filter::ParameterDefinition.new(:name, on: 'person') }
    let(:parameter) { MightyFetcher::Filter::Parameter.new('Stan', 'eq', definition) }

    it 'regenerate the right filter' do
      is_expected.to eq('person_name_eq' => 'Stan')
    end
  end

  context 'on polymorphic association (Several models)' do
    let(:definition) { MightyFetcher::Filter::ParameterDefinition.new(:tag_name, on: { resource: %w(Page Article) }) }
    let(:parameter) { MightyFetcher::Filter::Parameter.new('Scala', 'eq', definition) }

    it 'regenerate the right `or` filter' do
      is_expected.to eq('resource_of_Page_type_tag_name_or_resource_of_Article_type_tag_name_eq' => 'Scala')
    end
  end

  context 'on polymorphic association (one model)' do
    let(:definition) { MightyFetcher::Filter::ParameterDefinition.new(:tag_name, on: { resource: 'Page' }) }
    let(:parameter) { MightyFetcher::Filter::Parameter.new('Ruby', 'eq', definition) }

    it 'regenerate the right filter' do
      is_expected.to eq('resource_of_Page_type_tag_name_eq' => 'Ruby')
    end
  end

  context 'on attribute' do
    let(:definition) { MightyFetcher::Filter::ParameterDefinition.new(:name) }
    let(:parameter) { MightyFetcher::Filter::Parameter.new('Martin', 'eq', definition) }

    it 'regenerate the right filter' do
      is_expected.to eq('name_eq' => 'Martin')
    end
  end
end
