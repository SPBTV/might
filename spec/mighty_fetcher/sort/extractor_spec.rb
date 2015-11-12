require 'mighty_fetcher/sort/extractor'
require 'mighty_fetcher/sort/parameter_definition'

RSpec.describe MightyFetcher::Sort::Extractor do
  let(:name) { MightyFetcher::Sort::ParameterDefinition.new(:name, as: :title) }
  let(:surname) { MightyFetcher::Sort::ParameterDefinition.new(:surname) }

  let(:definitions) { Set.new([name, surname]) }

  context '#call' do
    subject(:extract) do
      described_class.new({ sort: sort_order }, definitions).call
    end

    context 'when known sort order given' do
      context 'without direction' do
        let(:parameter) { MightyFetcher::Sort::Parameter.new(:asc, surname) }
        let(:sort_order) { 'surname' }

        it 'returns Parameters' do
          is_expected.to contain_exactly(parameter)
        end
      end

      context 'with direction' do
        let(:parameter) { MightyFetcher::Sort::Parameter.new(:desc, surname) }
        let(:sort_order) { '-surname' }

        it 'returns Parameters' do
          is_expected.to contain_exactly(parameter)
        end
      end

      context 'with alias' do
        let(:parameter) { MightyFetcher::Sort::Parameter.new(:asc, name) }
        let(:sort_order) { 'title' }

        it 'returns Parameters' do
          is_expected.to contain_exactly(parameter)
        end
      end

      context 'with alias and direction' do
        let(:parameter) { MightyFetcher::Sort::Parameter.new(:desc, name) }
        let(:sort_order) { '-title' }

        it 'returns Parameters' do
          is_expected.to contain_exactly(parameter)
        end
      end
    end

    context 'when not known sort order given' do
      context 'without direction' do
        let(:parameter) { MightyFetcher::Sort::Parameter.new(:asc, MightyFetcher::Sort::UndefinedParameter.new('unknown')) }
        let(:sort_order) { 'unknown' }

        it 'returns Parameters' do
          is_expected.to contain_exactly(parameter)
        end
      end

      context 'aliased with another name' do
        let(:parameter) { MightyFetcher::Sort::Parameter.new(:asc, MightyFetcher::Sort::UndefinedParameter.new('name')) }
        let(:sort_order) { 'name' }

        it 'returns Parameters' do
          is_expected.to contain_exactly(parameter)
        end
      end
    end

    context 'when multiple of sort orders given' do
      let(:name_parameter) { MightyFetcher::Sort::Parameter.new(:desc, name) }
      let(:undefined_parameter) { MightyFetcher::Sort::Parameter.new(:asc, MightyFetcher::Sort::UndefinedParameter.new('undefined')) }
      let(:surname_parameter) { MightyFetcher::Sort::Parameter.new(:asc, surname) }
      let(:sort_order) { 'undefined,-title,surname' }

      it 'returns Parameters' do
        is_expected.to eq([undefined_parameter, name_parameter, surname_parameter])
      end
    end
  end
end
