require 'mighty_fetcher/ransackable_filter_parameters_adapter'
require 'mighty_fetcher/filter_parameter'
require 'mighty_fetcher/filter_parameter_definition'

RSpec.describe MightyFetcher::RansackableFilterParametersAdapter do
  let(:converter) do
    described_class.new(->(env) { env[1] })
  end

  subject { converter.call([nil, { filter: [parameter] }])[:filter] }

  context 'on association' do
    let(:definition) { MightyFetcher::FilterParameterDefinition.new(:name, on: 'person') }
    let(:parameter) { MightyFetcher::FilterParameter.new('Stan', 'eq', definition) }

    it 'regenerate the right filter' do
      is_expected.to eq('person_name_eq' => 'Stan')
    end
  end

  context 'on polymorphic association (Several models)' do
    let(:definition) { MightyFetcher::FilterParameterDefinition.new(:tag_name, on: { resource: %w(Page Article) }) }
    let(:parameter) { MightyFetcher::FilterParameter.new('Scala', 'eq', definition) }

    it 'regenerate the right `or` filter' do
      is_expected.to eq('resource_of_Page_type_tag_name_or_resource_of_Article_type_tag_name_eq' => 'Scala')
    end
  end

  context 'on polymorphic association (one model)' do
    let(:definition) { MightyFetcher::FilterParameterDefinition.new(:tag_name, on: { resource: 'Page' }) }
    let(:parameter) { MightyFetcher::FilterParameter.new('Ruby', 'eq', definition) }

    it 'regenerate the right filter' do
      is_expected.to eq('resource_of_Page_type_tag_name_eq' => 'Ruby')
    end
  end

  context 'on attribute' do
    let(:definition) { MightyFetcher::FilterParameterDefinition.new(:name) }
    let(:parameter) { MightyFetcher::FilterParameter.new('Martin', 'eq', definition) }

    it 'regenerate the right filter' do
      is_expected.to eq('name_eq' => 'Martin')
    end
  end
end
