require 'might/pagination_parameters_validator'

RSpec.describe Might::PaginationParametersValidator do
  let(:errors) { ['The error'] }
  let(:validator) do
    app = ->(env) { env }
    described_class.new(app)
  end

  before :all do
    I18n.backend.store_translations(:en,
                                    activemodel: {
                                      errors: {
                                        messages: {
                                          invalid_page_type: 'is invalid',
                                          not_a_number: 'is not a number'
                                        }
                                      }
                                    }
                                   )
  end

  before do
    @processed_params, @processed_errors = validator.call([params, errors])
  end

  context 'page has invalid type' do
    let(:params) { { page: 'foobar' } }

    it 'leaves params unchanged' do
      expect(@processed_params).to eq(params)
    end

    it 'add error' do
      expect(@processed_errors).to contain_exactly('The error', 'Page is invalid')
    end
  end

  context 'limit has invalid type' do
    let(:params) { { page: { limit: 'many' } } }

    it 'leaves params unchanged' do
      expect(@processed_params).to eq(params)
    end

    it 'add error' do
      expect(@processed_errors).to contain_exactly('The error', 'Limit is not a number')
    end
  end

  context 'offset has invalid type' do
    let(:params) { { page: { offset: 'next' } } }

    it 'leaves params unchanged' do
      expect(@processed_params).to eq(params)
    end

    it 'add error' do
      expect(@processed_errors).to contain_exactly('The error', 'Offset is not a number')
    end
  end

  context 'offset and limit are not present' do
    let(:params) { { page: {} } }

    it 'leaves params unchanged' do
      expect(@processed_params).to eq(params)
    end

    it 'leave errors unchanged' do
      expect(@processed_errors).to contain_exactly('The error')
    end
  end

  context 'page is not given' do
    let(:params) { {} }

    it 'leaves params unchanged' do
      expect(@processed_params).to eq(params)
    end

    it 'leave errors unchanged' do
      expect(@processed_errors).to contain_exactly('The error')
    end
  end
end
