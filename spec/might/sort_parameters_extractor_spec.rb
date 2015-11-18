require 'set'
require 'might/sort_parameters_extractor'
require 'might/sort_parameter_definition'
require 'might/sort_parameter'

RSpec.describe Might::SortParametersExtractor do
  subject :extract do
    described_class.new(->(env) { env[0] }, definitions).call([params, nil])[:sort]
  end

  context 'when known sort order given' do
    context 'without direction' do
      let(:definition) { Might::SortParameterDefinition.new(:name) }
      let(:definitions) { Set.new([definition]) }
      let(:params) { { sort: 'name' } }

      it 'returns Parameters' do
        parameter = Might::SortParameter.new(:asc, definition)
        is_expected.to contain_exactly(parameter)
      end
    end

    context 'with direction' do
      let(:definition) { Might::SortParameterDefinition.new(:name) }
      let(:definitions) { Set.new([definition]) }
      let(:params) { { sort:  '-name' } }

      it 'returns Parameters' do
        parameter = Might::SortParameter.new(:desc, definition)
        is_expected.to contain_exactly(parameter)
      end
    end

    context 'with alias' do
      let(:definition) { Might::SortParameterDefinition.new(:name, as: :title) }
      let(:definitions) { Set.new([definition]) }
      let(:params) { { sort: 'title' } }

      it 'returns Parameters' do
        parameter = Might::SortParameter.new(:asc, definition)
        is_expected.to contain_exactly(parameter)
      end
    end

    context 'with alias and direction' do
      let(:definition) { Might::SortParameterDefinition.new(:name, as: :title) }
      let(:definitions) { Set.new([definition]) }
      let(:params) { { sort: '-title' } }

      it 'returns Parameters' do
        parameter = Might::SortParameter.new(:desc, definition)
        is_expected.to contain_exactly(parameter)
      end
    end
  end

  context 'when not known sort order given' do
    context 'without direction' do
      let(:definitions) { Set.new([]) }
      let(:params) { { sort: 'unknown' } }

      it 'returns Parameters' do
        parameter = Might::SortParameter.new(:asc, Might::SortUndefinedParameter.new('unknown'))
        is_expected.to contain_exactly(parameter)
      end
    end

    context 'aliased with another name' do
      let(:definition) { Might::SortParameterDefinition.new(:name, as: :title) }
      let(:definitions) { Set.new([definition]) }
      let(:params) { { sort: 'name' } }

      it 'is not accessible on original name' do
        parameter = Might::SortParameter.new(:asc, Might::SortUndefinedParameter.new('name'))
        is_expected.to contain_exactly(parameter)
      end
    end
  end

  context 'when multiple of sort orders given' do
    let(:aliased_definition) { Might::SortParameterDefinition.new(:name, as: :title) }
    let(:definition) { Might::SortParameterDefinition.new(:surname) }
    let(:definitions) { Set.new([aliased_definition, definition]) }
    let(:params) { { sort: 'undefined,-title,surname' } }

    it 'returns Parameters' do
      aliased_parameter = Might::SortParameter.new(:desc, aliased_definition)
      parameter = Might::SortParameter.new(:asc, definition)
      undefined_parameter = Might::SortParameter.new(:asc, Might::SortUndefinedParameter.new('undefined'))

      is_expected.to eq([undefined_parameter, aliased_parameter, parameter])
    end
  end
end
