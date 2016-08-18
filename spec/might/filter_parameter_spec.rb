require 'might/filter_parameter'
require 'might/filter_parameter_definition'

RSpec.describe Might::FilterParameter do
  before :all do
    I18n.backend.store_translations(:en,
                                    errors: {
                                      attributes: {
                                        resource_type: {
                                          inclusion: 'is not included in the list',
                                        },
                                      },
                                    },
                                   )
  end

  context '#provided?' do
    let(:definition) { Might::FilterParameterDefinition.new('test') }

    subject { described_class.new(value, predicate, definition) }

    context 'when value and predicate provided' do
      let(:value) { 'foo' }
      let(:predicate) { 'in' }

      it 'is provided' do
        is_expected.to be_provided
      end
    end

    context 'when no value and predicate provided' do
      let(:value) { nil }
      let(:predicate) { nil }

      it 'is not provided' do
        is_expected.not_to be_provided
      end
    end

    context 'when no value provided and predicate provided' do
      let(:value) { nil }
      let(:predicate) { 'in' }

      it 'is not provided' do
        is_expected.not_to be_provided
      end
    end

    context 'when value provided and no predicate provided' do
      let(:value) { 'test' }
      let(:predicate) { nil }

      it 'is not provided' do
        is_expected.not_to be_provided
      end
    end
  end

  context '#value' do
    let(:name) { 'the_name' }
    let(:value) { 'channels' }
    let(:predicate) { '_eq' }

    subject { described_class.new(value, predicate, definition).value }

    context 'when coercion defined' do
      let(:coerce) do
        ->(value) { value.classify }
      end

      let(:definition) do
        Might::FilterParameterDefinition.new(name, coerce: coerce)
      end

      context 'single value' do
        it 'is coerced' do
          is_expected.to eq('Channel')
        end
      end

      context 'array of values given' do
        let(:predicate) { '_in' }
        let(:value) { %w(channels movies) }

        it 'is coerced' do
          is_expected.to eq(%w(Channel Movie))
        end
      end
    end

    context 'when coercion is not defined' do
      let(:definition) do
        Might::FilterParameterDefinition.new(name)
      end

      it 'is not coerced' do
        is_expected.to eq('channels')
      end
    end
  end

  context 'validation' do
    let(:name) { 'resource_type' }
    let(:predicate) { '_eq' }

    subject(:parameter) { described_class.new(value, predicate, definition) }
    subject(:errors) { parameter.errors }
    before do
      parameter.valid?
    end

    context 'single value' do
      let(:definition) do
        Might::FilterParameterDefinition.new(name, validates: { inclusion: { in: %w(channels movies) } })
      end

      context 'when valid' do
        let(:value) { 'channels' }

        it 'is valid' do
          expect(parameter).to be_valid
        end
      end

      context 'when invalid' do
        let(:value) { 'episodes' }

        it 'is invalid' do
          expect(parameter).to be_invalid
        end
      end
    end

    context 'multiple values' do
      let(:definition) do
        Might::FilterParameterDefinition.new(name, validates: { inclusion: { in: %w(channels movies) } })
      end

      context 'when valid' do
        let(:value) { %w(channels movies) }

        it 'is valid' do
          expect(parameter).to be_valid
        end
      end

      context 'when invalid' do
        let(:value) { %w(channels episodes seasons movies) }

        it 'is invalid' do
          expect(parameter).to be_invalid
        end

        it 'flatten errors' do
          expect(errors).to contain_exactly('Resource type is not included in the list')
        end
      end
    end
  end
end
