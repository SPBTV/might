require 'mighty_fetcher/filter/ransackable_filter'
require 'mighty_fetcher/filter/parameter'
require 'mighty_fetcher/filter/parameter_definition'
require 'database_helper'

RSpec.describe MightyFetcher::Filter::RansackableFilter do
  let!(:stan) { Page.create(name: 'Stan Marsh') }
  let!(:kyle) { Page.create(name: 'Kyle Broflovski') }

  context '#filter' do
    subject do
      described_class.new(filters).filter(Page)
    end

    context 'when no filters given' do
      let(:filters) { nil }

      it 'does not change collection' do
        is_expected.to contain_exactly(*Page.all.to_a)
      end
    end

    context 'when filter given' do
      let(:filters) do
        [
          MightyFetcher::Filter::Parameter.new(
            'Stan', 'cont',
            MightyFetcher::Filter::ParameterDefinition.new(:name)
          ),
        ]
      end

      it 'apply all filters to collection' do
        is_expected.to contain_exactly(stan)
      end
    end
  end

  context '#filters' do
    subject { described_class.new(filters).filters }

    context 'on association' do
      let(:filters) do
        [
          MightyFetcher::Filter::Parameter.new(
            stan.name, 'eq',
            MightyFetcher::Filter::ParameterDefinition.new(:name, on: 'page')
          ),
        ]
      end

      it 'regenerate the right filter' do
        is_expected.to eq('page_name_eq' => stan.name)
      end
    end

    context 'on polymorphic association (Several models)' do
      let(:filters) do
        [
          MightyFetcher::Filter::Parameter.new(
            'Horror', 'eq',
            MightyFetcher::Filter::ParameterDefinition.new(:genre_name, on: { resource: %w(Movie Channel) })
          ),
        ]
      end

      it 'regenerate the right `or` filter' do
        is_expected.to eq('resource_of_Movie_type_genre_name_or_resource_of_Channel_type_genre_name_eq' => 'Horror')
      end
    end

    context 'on polymorphic association (one model)' do
      let(:filters) do
        [
          MightyFetcher::Filter::Parameter.new(
            'Horror', 'eq',
            MightyFetcher::Filter::ParameterDefinition.new(:genre_name, on: { resource: 'Movie' })
          ),
        ]
      end

      it 'regenerate the right filter' do
        is_expected.to eq('resource_of_Movie_type_genre_name_eq' => 'Horror')
      end
    end

    context 'on attribute' do
      let(:filters) do
        [
          MightyFetcher::Filter::Parameter.new(
            stan.name, 'eq',
            MightyFetcher::Filter::ParameterDefinition.new(:name)
          ),
        ]
      end

      it 'regenerate the right filter' do
        is_expected.to eq('name_eq' => stan.name)
      end
    end
  end
end
