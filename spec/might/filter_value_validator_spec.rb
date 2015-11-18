require 'might/filter_value_validator'
require 'might/filter_undefined_parameter'
require 'might/filter_parameter_definition'

RSpec.describe Might::FilterValueValidator do
  before :all do
    I18n.backend.store_translations(:en,
      activemodel: {
        errors: {
          messages: {
            undefined_filter: 'is not allowed filter name'
          }
        }
      }
    )
  end

  context '.build' do
    subject { definition.validator.new(value).tap(&:validate) }

    context 'defined parameter' do
      let(:definition) do
        Might::FilterParameterDefinition.new('first_name', validates: { presence: { message: "can't be blank" } })
      end

      context 'when valid value given' do
        let(:value) { 'foo' }

        it 'is valid' do
          is_expected.to be_valid
        end
      end

      context 'when invalid value given' do
        let(:value) { nil }

        it 'is invalid' do
          is_expected.not_to be_valid
        end

        it 'has the message with right attribute name' do
          messages = subject.errors.full_messages
          expect(messages).to contain_exactly("First name can't be blank")
        end
      end
    end

    context 'undefined parameter' do
      let(:definition) do
        Might::FilterUndefinedParameter.new('first_name')
      end

      let(:value) { 'foo' }

      it 'is invalid' do
        is_expected.not_to be_valid
      end

      it 'has the message with right attribute name' do
        messages = subject.errors.full_messages
        expect(messages).to contain_exactly('First name is not allowed filter name')
      end
    end
  end
end
