require 'set'
require 'mighty_fetcher/sort/parameters_extractor'
require 'mighty_fetcher/sort/parameter_definition'
require 'mighty_fetcher/sort/parameter'

RSpec.describe MightyFetcher::Sort::ParametersExtractor do
  subject :extract do
    described_class.new(->(env) { env[1] }, definitions).call([nil, params])
  end

  context 'when known sort order given' do
    context 'without direction' do
      let(:definition) { MightyFetcher::Sort::ParameterDefinition.new(:name) }
      let(:definitions) { Set.new([definition]) }
      let(:params) { 'name' }

      it 'returns Parameters' do
        parameter = MightyFetcher::Sort::Parameter.new(:asc, definition)
        is_expected.to contain_exactly(parameter)
      end
    end

    context 'with direction' do
      let(:definition) { MightyFetcher::Sort::ParameterDefinition.new(:name) }
      let(:definitions) { Set.new([definition]) }
      let(:params) { '-name' }

      it 'returns Parameters' do
        parameter = MightyFetcher::Sort::Parameter.new(:desc, definition)
        is_expected.to contain_exactly(parameter)
      end
    end

    context 'with alias' do
      let(:definition) { MightyFetcher::Sort::ParameterDefinition.new(:name, as: :title) }
      let(:definitions) { Set.new([definition]) }
      let(:params) { 'title' }

      it 'returns Parameters' do
        parameter = MightyFetcher::Sort::Parameter.new(:asc, definition)
        is_expected.to contain_exactly(parameter)
      end
    end

    context 'with alias and direction' do
      let(:definition) { MightyFetcher::Sort::ParameterDefinition.new(:name, as: :title) }
      let(:definitions) { Set.new([definition]) }
      let(:params) { '-title' }

      it 'returns Parameters' do
        parameter = MightyFetcher::Sort::Parameter.new(:desc, definition)
        is_expected.to contain_exactly(parameter)
      end
    end
  end

  context 'when not known sort order given' do
    context 'without direction' do
      let(:definitions) { Set.new([]) }
      let(:params) { 'unknown' }

      it 'returns Parameters' do
        parameter = MightyFetcher::Sort::Parameter.new(:asc, MightyFetcher::Sort::UndefinedParameter.new('unknown'))
        is_expected.to contain_exactly(parameter)
      end
    end

    context 'aliased with another name' do
      let(:definition) { MightyFetcher::Sort::ParameterDefinition.new(:name, as: :title) }
      let(:definitions) { Set.new([definition]) }
      let(:params) { 'name' }

      it 'is not accessible on original name' do
        parameter = MightyFetcher::Sort::Parameter.new(:asc, MightyFetcher::Sort::UndefinedParameter.new('name'))
        is_expected.to contain_exactly(parameter)
      end
    end
  end

  context 'when multiple of sort orders given' do
    let(:aliased_definition) { MightyFetcher::Sort::ParameterDefinition.new(:name, as: :title) }
    let(:definition) { MightyFetcher::Sort::ParameterDefinition.new(:surname) }
    let(:definitions) { Set.new([aliased_definition, definition]) }
    let(:params) { 'undefined,-title,surname' }

    it 'returns Parameters' do
      aliased_parameter = MightyFetcher::Sort::Parameter.new(:desc, aliased_definition)
      parameter = MightyFetcher::Sort::Parameter.new(:asc, definition)
      undefined_parameter = MightyFetcher::Sort::Parameter.new(:asc, MightyFetcher::Sort::UndefinedParameter.new('undefined'))

      is_expected.to eq([undefined_parameter, aliased_parameter, parameter])
    end
  end
end
