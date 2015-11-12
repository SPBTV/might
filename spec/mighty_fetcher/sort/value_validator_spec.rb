require 'mighty_fetcher/sort/value_validator'
require 'mighty_fetcher/sort/undefined_parameter'
require 'mighty_fetcher/sort/parameter_definition'

RSpec.describe MightyFetcher::Sort::ValueValidator do
  before :all do
    I18n.backend.store_translations(:en,
      activemodel: {
        errors: {
          messages: {
            undefined_sort_order: 'is not allowed sort order'
          }
        }
      }
    )
  end

  subject { definition.validator.tap(&:validate) }

  context 'defined parameter' do
    let(:definition) do
      MightyFetcher::Sort::ParameterDefinition.new('first_name')
    end

    it 'is valid' do
      is_expected.to be_valid
    end
  end

  context 'undefined parameter' do
    let(:definition) do
      MightyFetcher::Sort::UndefinedParameter.new('first_name')
    end

    it 'is invalid' do
      is_expected.not_to be_valid
    end

    it 'has the message with right attribute name' do
      messages = subject.errors.full_messages
      expect(messages).to contain_exactly('First name is not allowed sort order')
    end
  end
end
