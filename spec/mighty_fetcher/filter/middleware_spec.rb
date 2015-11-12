require 'middleware'
require 'mighty_fetcher/validation_error'
require 'mighty_fetcher/filter/middleware'
require 'database_helper'

RSpec.describe MightyFetcher::Filter::Middleware do
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

  before do
    3.times { |n| Page.create!(name: "Foobar #{n}") }
  end

  let!(:pages) { Page.all }
  let(:page) { pages.first }

  subject do
    Middleware::Builder.new do |b|
      b.use described_class, parameters_definition
      b.use ->(env) { env.first.all }
    end.call([pages, { filter: filter_params }]).to_a
  end

  context 'when some filter is required' do
    let(:parameters_definition) do
      [
        MightyFetcher::Filter::ParameterDefinition.new(:name, validates: { presence: true }),
        MightyFetcher::Filter::ParameterDefinition.new(:slug),
      ]
    end

    context 'and it is not given' do
      let(:filter_params) { {} }

      it 'fails with error' do
        expect do
          subject
        end.to raise_error(MightyFetcher::FilterValidationFailed) { |error|
                 expect(error.message).to eq("Name can't be blank")
               }
      end
    end

    context 'and it is given' do
      let(:filter_params) { { 'name_eq' => page.name } }

      it 'return found objects' do
        is_expected.to contain_exactly(page)
      end
    end
  end

  context 'when no filters required' do
    let(:parameters_definition) do
      [
        MightyFetcher::Filter::ParameterDefinition.new(:name),
      ]
    end

    context 'and no filters given' do
      let(:filter_params) { {} }

      it 'return all objects' do
        is_expected.to contain_exactly(*pages)
      end
    end

    context 'and filter given' do
      let(:filter_params) { { 'name_eq' => page.name } }

      it 'return found objects' do
        is_expected.to contain_exactly(page)
      end
    end

    context 'and no matching filter given' do
      let(:filter_params) { { 'name_eq' => 'invalid' } }

      it 'return no objects' do
        is_expected.to be_empty
      end
    end

    context 'and not allowed filter given' do
      let(:filter_params) { { 'slug_eq' => 'test' } }

      it 'return no objects' do
        expect do
          subject
        end.to raise_error(MightyFetcher::FilterValidationFailed) { |error|
          expect(error.message).to eq('Slug is not allowed filter name')
        }
      end
    end
  end

  context 'validations' do
    let(:parameters_definition) do
      [
        MightyFetcher::Filter::ParameterDefinition.new(:name, validates: { length: { minimum: 3 } }),
        MightyFetcher::Filter::ParameterDefinition.new(:slug),
      ]
    end

    context 'and it is invalid' do
      let(:filter_params) { { 'name_eq' => 'xy' } }

      it 'fails with error' do
        expect do
          subject
        end.to raise_error(MightyFetcher::FilterValidationFailed) { |error|
                 expect(error.message).to eq('Name is too short (minimum is 3 characters)')
               }
      end
    end

    context 'and it is valid' do
      let(:filter_params) { { 'name_eq' => page.name } }

      it 'return found objects' do
        is_expected.to contain_exactly(page)
      end
    end
  end
end
