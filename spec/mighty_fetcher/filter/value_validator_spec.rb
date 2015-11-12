require 'mighty_fetcher/filter/value_validator'
require 'mighty_fetcher/filter/undefined_parameter'
require 'mighty_fetcher/filter/parameter_definition'

RSpec.describe MightyFetcher::Filter::ValueValidator do
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
        MightyFetcher::Filter::ParameterDefinition.new('first_name', validates: { presence: { message: "can't be blank" } })
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
        MightyFetcher::Filter::UndefinedParameter.new('first_name')
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
