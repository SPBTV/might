# frozen_string_literal: true
RSpec.describe Might::FilterParameters do
  let(:parameter_definition) { Might::FilterParameterDefinition.new(:height) }
  let(:parameter) { Might::FilterParameter.new('146', 'eq', parameter_definition) }
  let(:filter_parameters) { described_class.new([parameter]) }

  shared_examples 'returns new object' do
    it 'returns another object of the same type' do
      is_expected.to be_kind_of(Might::FilterParameters)
      is_expected.not_to equal(filters)
    end
  end

  describe '#[]' do
    subject { filter_parameters[parameter_name] }

    context 'when existing parameter name given' do
      let(:parameter_name) { 'height' }

      it 'returns parameter with this name' do
        is_expected.to eq(parameter)
      end

      context 'when predicate is specified' do
        let(:predicate) { 'in' }
        let(:second_parameter) { Might::FilterParameter.new('146', predicate, parameter_definition) }
        let(:filter_parameters) { described_class.new([parameter, second_parameter]) }

        it 'returns parameter with this name and predicate' do
          expect(filter_parameters[parameter_name, predicate]).to eq(second_parameter)
        end
      end
    end

    context 'when parameter name given is absent' do
      let(:parameter_name) { 'width' }

      it 'returns nil' do
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

      context 'when predicate is specified' do
        let(:predicate) { 'in' }
        let(:second_parameter) { Might::FilterParameter.new('146', predicate, parameter_definition) }
        let(:filter_parameters) { described_class.new([parameter, second_parameter]) }

        it 'returns parameter with this name and predicate' do
          expect(filter_parameters.fetch(parameter_name, predicate)).to eq(second_parameter)
        end
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

  describe '#delete' do
    subject(:delete) { filter_parameters.delete(parameter_name) }

    context 'when existing parameter name given' do
      let(:parameter_name) { 'height' }

      it 'returns parameter with this name' do
        is_expected.to eq(parameter)
        expect(filter_parameters[parameter_name]).to eq(nil)
      end

      context 'when predicate is specified' do
        let(:predicate) { 'in' }
        let(:second_parameter) { Might::FilterParameter.new('146', predicate, parameter_definition) }
        let(:filter_parameters) { described_class.new([parameter, second_parameter]) }

        it 'returns parameter with this name and predicate' do
          param = filter_parameters.delete(parameter_name, predicate)
          expect(param).to eq(second_parameter)
          expect(filter_parameters[parameter_name, predicate]).to eq(nil)
        end
      end
    end

    context 'when parameter name given is absent' do
      let(:parameter_name) { :width }

      it 'returns nil' do
        is_expected.to eq(nil)
      end
    end
  end

  describe '#-' do
    let(:filters) { Might::FilterParameters.new([1, 2]) }
    let(:other_filters) { Might::FilterParameters.new([1, 3]) }
    subject(:subtraction) { filters - other_filters }

    include_examples 'returns new object'

    it 'result object contains values not in second object' do
      is_expected.to eq(Might::FilterParameters.new([2]))
    end
  end

  describe '#+' do
    let(:filters) { Might::FilterParameters.new([1, 2]) }
    let(:other_filters) { Might::FilterParameters.new([1, 3]) }
    subject(:addition) { filters + other_filters }

    include_examples 'returns new object'

    it 'result object contains values from both objects' do
      is_expected.to eq(Might::FilterParameters.new([1, 2, 3]))
    end
  end

  describe '#add' do
    let(:filters) { Might::FilterParameters.new([1, 2]) }
    subject(:add) { filters.add(3) }

    include_examples 'returns new object'

    it 'result object contains values from original object plus added value' do
      is_expected.to eq(Might::FilterParameters.new([1, 2, 3]))
    end
  end

  describe '#map' do
    let(:filters) { Might::FilterParameters.new([1, 2]) }
    subject(:mapped) { filters.map { |v| v * 2 } }

    include_examples 'returns new object'

    it 'maps values inside container' do
      is_expected.to eq(Might::FilterParameters.new([2, 4]))
    end
  end
end
