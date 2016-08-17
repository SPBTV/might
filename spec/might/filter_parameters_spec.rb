require 'might/filter_parameters'
require 'might/filter_parameter_definition'
require 'might/filter_parameter'

RSpec.describe Might::FilterParameters do
  let(:parameter_definition) { Might::FilterParameterDefinition.new(:height) }
  let(:parameter) { Might::FilterParameter.new('146', 'eq', parameter_definition) }
  let(:filter_parameters) { described_class.new([parameter]) }

  describe '#[]' do
    subject { filter_parameters[parameter_name] }

    context 'when existing parameter name given' do
      let(:parameter_name) { 'height' }

      it 'returns parameter with this name' do
        is_expected.to eq(parameter)
      end
    end

    context 'when parameter name given is absent' do
      let(:parameter_name) { 'width' }

      it 'returns parameter with this name' do
        is_expected.to be_nil
      end
    end
  end

  describe '#fetch' do
    subject(:fetch) { filter_parameters.fetch(parameter_name) }

    context 'when existing parameter name given' do
      let(:parameter_name) { 'height' }

      it 'returns parameter with this name' do
        is_expected.to eq(parameter)
      end
    end

    context 'when parameter name given is absent' do
      let(:parameter_name) { :width }

      it 'fails with filter error' do
        expect do
          fetch
        end.to raise_error(Might::FilterParameters::FilterError, 'filter not found: :width')
      end
    end

    context 'with optional block passed' do
      NoSuchFilterError = Class.new(StandardError)
      subject(:fetch) do
        filter_parameters.fetch(parameter_name) do |name|
          fail NoSuchFilterError, name
        end
      end

      context 'when existing parameter name given' do
        let(:parameter_name) { 'height' }

        it 'returns parameter with this name' do
          is_expected.to eq(parameter)
        end
      end

      context 'when parameter name given is absent' do
        let(:parameter_name) { :width }

        it 'returns block value' do
          expect do
            fetch
          end.to raise_error(NoSuchFilterError, 'width')
        end
      end
    end
  end

  describe '#map' do
    let(:filters) { Might::FilterParameters.new([1, 2]) }
    subject(:mapped) { filters.map { |v| v * 2 } }

    it 'returns another object of the same type' do
      is_expected.to be_kind_of(Might::FilterParameters)
      is_expected.not_to equal(filters)
    end

    it 'maps values inside container' do
      is_expected.to eq(Might::FilterParameters.new([2, 4]))
    end
  end
end
