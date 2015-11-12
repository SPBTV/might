require 'set'
require 'mighty_fetcher/sort_parameters_extractor'
require 'mighty_fetcher/sort_parameter_definition'
require 'mighty_fetcher/sort_parameter'

RSpec.describe MightyFetcher::SortParametersExtractor do
  subject :extract do
    described_class.new(->(env) { env[1] }, definitions).call([nil, params])
  end

  context 'when known sort order given' do
    context 'without direction' do
      let(:definition) { MightyFetcher::SortParameterDefinition.new(:name) }
      let(:definitions) { Set.new([definition]) }
      let(:params) { 'name' }

      it 'returns Parameters' do
        parameter = MightyFetcher::SortParameter.new(:asc, definition)
        is_expected.to contain_exactly(parameter)
      end
    end

    context 'with direction' do
      let(:definition) { MightyFetcher::SortParameterDefinition.new(:name) }
      let(:definitions) { Set.new([definition]) }
      let(:params) { '-name' }

      it 'returns Parameters' do
        parameter = MightyFetcher::SortParameter.new(:desc, definition)
        is_expected.to contain_exactly(parameter)
      end
    end

    context 'with alias' do
      let(:definition) { MightyFetcher::SortParameterDefinition.new(:name, as: :title) }
      let(:definitions) { Set.new([definition]) }
      let(:params) { 'title' }

      it 'returns Parameters' do
        parameter = MightyFetcher::SortParameter.new(:asc, definition)
        is_expected.to contain_exactly(parameter)
      end
    end

    context 'with alias and direction' do
      let(:definition) { MightyFetcher::SortParameterDefinition.new(:name, as: :title) }
      let(:definitions) { Set.new([definition]) }
      let(:params) { '-title' }

      it 'returns Parameters' do
        parameter = MightyFetcher::SortParameter.new(:desc, definition)
        is_expected.to contain_exactly(parameter)
      end
    end
  end

  context 'when not known sort order given' do
    context 'without direction' do
      let(:definitions) { Set.new([]) }
      let(:params) { 'unknown' }

      it 'returns Parameters' do
        parameter = MightyFetcher::SortParameter.new(:asc, MightyFetcher::SortUndefinedParameter.new('unknown'))
        is_expected.to contain_exactly(parameter)
      end
    end

    context 'aliased with another name' do
      let(:definition) { MightyFetcher::SortParameterDefinition.new(:name, as: :title) }
      let(:definitions) { Set.new([definition]) }
      let(:params) { 'name' }

      it 'is not accessible on original name' do
        parameter = MightyFetcher::SortParameter.new(:asc, MightyFetcher::SortUndefinedParameter.new('name'))
        is_expected.to contain_exactly(parameter)
      end
    end
  end

  context 'when multiple of sort orders given' do
    let(:aliased_definition) { MightyFetcher::SortParameterDefinition.new(:name, as: :title) }
    let(:definition) { MightyFetcher::SortParameterDefinition.new(:surname) }
    let(:definitions) { Set.new([aliased_definition, definition]) }
    let(:params) { 'undefined,-title,surname' }

    it 'returns Parameters' do
      aliased_parameter = MightyFetcher::SortParameter.new(:desc, aliased_definition)
      parameter = MightyFetcher::SortParameter.new(:asc, definition)
      undefined_parameter = MightyFetcher::SortParameter.new(:asc, MightyFetcher::SortUndefinedParameter.new('undefined'))

      is_expected.to eq([undefined_parameter, aliased_parameter, parameter])
    end
  end
end
