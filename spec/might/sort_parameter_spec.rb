# frozen_string_literal: true
RSpec.describe Might::SortParameter do
  context '#direction' do
    subject(:parameter) { described_class.new(:asc, definition) }
    subject(:direction) { parameter.direction }

    context 'when reversed direction defined' do
      let(:definition) { Might::SortParameterDefinition.new(:relevance, reverse_direction: true) }

      it 'returns opposite direction' do
        is_expected.to eq('desc')
      end
    end

    context 'when no reversed direction defined' do
      let(:definition) { Might::SortParameterDefinition.new(:relevance) }

      it 'returns the same direction' do
        is_expected.to eq('asc')
      end
    end
  end
end
